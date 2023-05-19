import UIKit

class MainViewController: UITabBarController {

    private var message: String?
    private var contact: String?
    private var mobile: String?
    
    init(message: String? = "Dummy", contact: String? = "Dummy", mobile: String? = "Dummy") {
        self.message = message
        self.contact = contact
        self.mobile = mobile
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.itemPositioning = .fill
        setupView()
    }

    func setupView() {
        let chatVC = createViewController(with: ChatsViewController(message: message), title: "Chats", imageName: "chats")
        let contactsVC = createViewController(with: ContactsViewController(contact: contact, mobile: mobile), title: "Contacts", imageName: "contacts")
        let settingsVC = createViewController(with: SettingsViewController(), title: "Settings", imageName: "settings")

        viewControllers = [chatVC, contactsVC, settingsVC]
    }

    func createViewController(with rootViewController: UIViewController, title: String, imageName: String) -> UINavigationController {
        rootViewController.navigationItem.title = title
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = UIImage(named: imageName)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 5)

        let appearance = UITabBarItem.appearance()
        let font = UIFont.systemFont(ofSize: 14)
        let attributes = [NSAttributedString.Key.font: font]
        appearance.setTitleTextAttributes(attributes, for: .normal)
        appearance.setTitleTextAttributes(attributes, for: .selected)

        return navigationController
    }
}
