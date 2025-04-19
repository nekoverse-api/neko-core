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
}
