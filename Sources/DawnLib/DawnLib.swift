// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
public class LoginManager {
    public init() {}
    public func login(username: String, password: String) -> Bool {
        // Example login validation logic
        return username == "admin" && password == "password"
    }
    public func logout() {
        print("User logged out")
    }
}
