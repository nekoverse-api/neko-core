import SwiftyJSON
import Testing

@testable import NekoCore

typealias Template = NekoCore.NekoMustacheTemplate

@Suite
struct NekoMustacheTemplateTests {
    @Test
    func testReplaceVariables() async throws {
        let vars = JSON()
        let value = Template.replaceVariables("https://echo.necoverse.me", vars)

        #expect("https://echo.necoverse.me".isEqual(value))
    }

    @Test
    func testReplaceVariablesWithVariable() async throws {
        let vars = ["host": "echo.necoverse.me"]
        let value = Template.replaceVariables("https://{{host}}/test", JSON(vars))

        #expect("https://echo.necoverse.me/test".isEqual(value))
    }

    @Test
    func testReplaceVariablesWithNestedVariable() async throws {
        let vars: [String: Any] = ["host": "echo.necoverse.me", "user": ["sid": "456"]]
        let value = Template.replaceVariables("https://{{host}}/test?user={{user.sid}}", JSON(vars))

        #expect("https://echo.necoverse.me/test?user=456".isEqual(value))
    }

    @Test
    func testReplaceVariablesWithManyVariables() async throws {
        let vars = ["host": "echo.necoverse.me", "userId": "3121", "q": "Gary"]
        let template = "https://{{host}}/users/{{userId}}/query/{{q}}"
        let value = Template.replaceVariables(template, JSON(vars))

        #expect("https://echo.necoverse.me/users/3121/query/Gary".isEqual(value))
    }

    @Test
    func testReplaceVariablesWithManyRepetitions() async throws {
        let vars = ["host": "echo.necoverse.me", "env": "prod"]
        let template = "https://{{host}}/envs/{{env}}/{{env}}/{{env}}/{{env}}"
        let value = Template.replaceVariables(template, JSON(vars))

        #expect("https://echo.necoverse.me/envs/prod/prod/prod/prod".isEqual(value))
    }

    @Test
    func testReplaceVariablesSafeWithMissingVariables() async throws {
        let vars = [String: String]()
        let template = "https://-{{host}}/envs/missing_{{env}}_value/{{env}}"
        let value = Template.replaceVariables(template, JSON(vars))
        #expect("https://-/envs/missing__value/".isEqual(value))
    }

    @Test
    func testReplaceDictionaryVariables() async throws {
        let vars = [String: String]()
        let headers = [String: String]()
        let values = Template.replaceDictionaryVariables(headers, JSON(vars))

        #expect(values.count == 0)
        #expect(headers.count == values.count)

    }

    @Test
    func testReplaceDictionaryVariablesWithValues() async throws {
        let vars = ["customType": "json"]
        let headers = ["Content-Type": "applicaiton/{{customType}}"]
        let values = Template.replaceDictionaryVariables(headers, JSON(vars))

        #expect(values.count == 1)
        #expect(headers.count == values.count)
        #expect("applicaiton/json".isEqual(values["Content-Type"]))
    }

    @Test
    func testReplaceDictionaryVariablesWithKey() async throws {
        let vars = ["customHeader": "Neko"]
        let headers = ["x-{{customHeader}}-Custom-Type": "Active"]
        let values = Template.replaceDictionaryVariables(headers, JSON(vars))

        #expect(values.count == 1)
        #expect(headers.count == values.count)
        #expect(values.contains { $0.key.isEqual("x-Neko-Custom-Type") })
        #expect("Active".isEqual(values["x-Neko-Custom-Type"]))
    }

    @Test
    func testReplaceDictionaryVariablesWithKeyAndValues() async throws {
        let vars = [
            "customHeader": "Neko",
            "customType": "json",
        ]
        let headers = [
            "x-{{customHeader}}-Custom-Type": "Active",
            "Content-Type": "applicaiton/{{customType}}",
        ]
        let values = Template.replaceDictionaryVariables(headers, JSON(vars))

        #expect(values.count == 2)
        #expect(headers.count == values.count)

        #expect("applicaiton/json".isEqual(values["Content-Type"]))

        #expect(values.contains { $0.key.isEqual("x-Neko-Custom-Type") })
        #expect("Active".isEqual(values["x-Neko-Custom-Type"]))
    }

    @Test
    func testReplaceDictionaryVariablesWithEmptyKeyShouldBeRemoved() async throws {
        let vars = ["customHeader": ""]
        let headers = [
            "{{customHeader}": "Active",
            "": "Enabled",
            "  ": "Test",
            "\n": "TEST",
        ]
        let values = Template.replaceDictionaryVariables(headers, JSON(vars))

        #expect(values.count == 0)
        #expect(headers.count != values.count)
    }

    @Test
    func testReplaceDictionaryVariablesWithEmptyKeyShouldBeRemovedAndKeepOther() async throws {
        let vars = ["customHeader": ""]
        let headers = [
            "{{customHeader}": "Active",
            "": "Enabled",
            "  ": "Test",
            "\n": "TEST",
            "Content-Type": "applicaiton/json",
        ]
        let values = Template.replaceDictionaryVariables(headers, JSON(vars))

        #expect(values.count == 1)
        #expect(headers.count != values.count)

        #expect("applicaiton/json".isEqual(values["Content-Type"]))
    }

    @Test
    func testReplaceRequestVariables() async throws {
        let vars: [String: Any] = [
            "url": "https://echo.nekoverse.me",
            "method": "POST",
            "user": [
                "id": "1234",
                "name": "Gary Ascuy",
                "bio": "Software Developer, Robotic & Cat Lover, and Chef Amateur",
            ],
            "secrets": [
                "token": "S0m3-P4$$W0rD"
            ],
        ]

        let http = NekoHttp(
            url: "{{url}}/users/{{user.id}}",
            method: "{{method}}",
            body:
                """
                {
                    "userName": "TestName-{{user.name}}",
                    "userBio": "TestBio-{{user.bio}}"
                }
                """,
            parameters: [
                "owner": "owner_{{user.id}}"
            ],
            headers: [
                "Authorization": "Basic {{secrets.token}}",
                "Content-Type": "application/json",
                "Accept": "application/json",
                "x-User-Id": "{{user.id}}",
            ]
        )

        let request = Template.replaceRequestVariables(http, JSON(vars))

        #expect("https://echo.nekoverse.me/users/1234".isEqual(request.url))
        #expect("POST".isEqual(request.method))

        #expect(request.body != nil)
        let body = JSON(parseJSON: request.body!)
        print(body)
        #expect("TestName-Gary Ascuy".isEqual(body["userName"].stringValue))
        #expect(
            "TestBio-Software Developer, Robotic &amp; Cat Lover, and Chef Amateur".isEqual(
                body["userBio"].stringValue))

        #expect(request.parameters.count == 1)
        #expect("owner_1234".isEqual(request.parameters["owner"]))

        #expect(request.headers.count == 4)
        #expect("Basic S0m3-P4$$W0rD".isEqual(request.headers["Authorization"]))
        #expect("application/json".isEqual(request.headers["Content-Type"]))
        #expect("application/json".isEqual(request.headers["Accept"]))
        #expect("1234".isEqual(request.headers["x-User-Id"]))
    }
}
