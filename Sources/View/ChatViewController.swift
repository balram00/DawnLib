//
//  ChatViewController.swift
//  DawnLib
//
//  Created by bitcot on 18/12/24.
//

import UIKit

public class ChatViewController: UIViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let label = UILabel()
        label.text = "Welcome to Chat!"
        label.textAlignment = .center
        label.frame = view.bounds
        view.addSubview(label)
    }
}
