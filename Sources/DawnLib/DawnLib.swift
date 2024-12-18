// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import UIKit

import UIKit

public class ChatLauncher {
    
    @MainActor public static let shared = ChatLauncher() // Singleton instance

    private init() {} // Prevent direct initialization
    
    /// Method to present ChatViewController as the starting page
    @MainActor public func launchChat(from window: UIWindow?) {
        guard let window = window else {
            print("Error: UIWindow is nil")
            return
        }
        
        // Create an instance of ChatViewController
        let chatViewController = ChatViewController()
        // Set up a navigation controller (optional but recommended)
        let navigationController = UINavigationController(rootViewController: chatViewController)
        
        // Set the navigation controller as the root view controller
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
