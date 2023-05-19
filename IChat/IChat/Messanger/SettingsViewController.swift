import UIKit

class SettingsViewController: UIViewController {
    
    private let logoutButton: UIButton = {
        let myBtn = UIButton(type: .system)
        myBtn.setTitle("Logout", for: .normal)
        myBtn.addTarget(self,action: #selector(logoutButtonTapped),for: .touchUpInside);
        myBtn.translatesAutoresizingMaskIntoConstraints = false;
        return myBtn
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupView()
    }
    
    private func setupView() {
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc func logoutButtonTapped() {
        let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Log Out", style: .destructive) { _ in
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            print("Logged Out Successfully")
            self.showLoginVC()
        }
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        present(alert, animated: true, completion: nil)
    }
        
    func showLoginVC() {
        let loginVC = LoginViewController()
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            window.rootViewController = loginVC
            window.makeKeyAndVisible()
        }
    }
}
