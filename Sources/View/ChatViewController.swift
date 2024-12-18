//
//  ChatViewController.swift
//  DawnLib
//
//  Created by bitcot on 18/12/24.
//

import UIKit

import UIKit

public class ChatViewController: UIViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    public static func instantiate() -> ChatViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.module)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController else {
            fatalError("ChatViewController not found in Main.storyboard")
        }
        return viewController
    }
}
