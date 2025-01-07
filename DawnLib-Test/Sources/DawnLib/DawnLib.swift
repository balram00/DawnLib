// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import UIKit


public class ChatLauncher {
    
    @MainActor public static let shared = ChatLauncher()
    
    private init() {} 
 
    @MainActor public func launchChat(from navigationController: UINavigationController?) -> Bool {
        guard let navigationController = navigationController else {
            print("Error: NavigationController is nil")
            return false
        }
        
        guard let chatViewController = ChatViewController.instantiate() else {
            print("Error: ChatViewController could not be instantiated.")
            return false
        }
        
        navigationController.pushViewController(chatViewController, animated: true)
        return true
    }
}
