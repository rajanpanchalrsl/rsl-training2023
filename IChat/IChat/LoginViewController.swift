import UIKit

class LoginViewController: UIViewController {

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "icon")
        return imageView
    }()
    
    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Username"
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 22)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        setupModel()
        setupView()
    }
    
    func setupModel() {
        UserDefaults.standard.set("rajan-rsl", forKey: "username")
        UserDefaults.standard.set("rsl@Rajan23", forKey: "password")
    }
    
    func setupView() {
        view.addSubview(imageView)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            
            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameTextField.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            usernameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 15),
            passwordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.widthAnchor.constraint(equalToConstant: 250),
            loginButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func loginButtonTapped() {
        guard let username = usernameTextField.text, !username.isEmpty else {
            showAlert(message: "Username Field can't be Empty")
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Password Field can't be Empty")
            return
        }
        
        if let storedUsername = UserDefaults.standard.string(forKey: "username"),
           let storedPassword = UserDefaults.standard.string(forKey: "password") {
            if username == storedUsername && password == storedPassword {
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                print("Logged In Successfully")
                showMainVC()
            } else {
                showAlert(message: "Invalid Username or Password")
            }
        } else {
            showAlert(message: "No Record found on Database")
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showMainVC() {
        let mainVC = MainViewController()
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            window.rootViewController = mainVC
            window.makeKeyAndVisible()
        }
    }
}


