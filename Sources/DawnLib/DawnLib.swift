// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import UIKit

import UIKit

public class ChatLauncher {
    
    @MainActor public static let shared = ChatLauncher() // Singleton instance

    private init() {} // Prevent direct initialization

    /// Method to push ChatViewController
    @MainActor public func launchChat(from navigationController: UINavigationController?) {
        guard let navigationController = navigationController else {
            print("Error: NavigationController is nil")
            return
        }
        
        let chatViewController = ChatViewController.instantiate()
        navigationController.pushViewController(chatViewController, animated: true)
    }
}
