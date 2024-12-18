import UIKit

public class ChatViewController: UIViewController {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Initialization code
        view.backgroundColor = .green
    }
//    
    public static func instantiate() -> ChatViewController {
        // Ensure Bundle.module contains the storyboard
        guard let storyboard = try? UIStoryboard(name: "Main", bundle: Bundle.module) else {
            fatalError("Main.storyboard not found in Bundle.module")
        }
        
        // Instantiate ChatViewController from the storyboard
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController else {
            fatalError("ChatViewController not found in Main.storyboard or identifier mismatch")
        }
        
        return viewController
    }
}
