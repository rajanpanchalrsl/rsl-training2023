import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")

    private let deepLinkURLSchema = "ichatmessanger"
    private let validHosts: [String] = ["chat", "contact", "settings"]

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        if let url = connectionOptions.urlContexts.first?.url {
            viewControllerForDeepLinkURL(url)
            return
        }
        let viewController = isLoggedIn ? MainViewController() : LoginViewController()
        setRootViewController(viewController)
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        viewControllerForDeepLinkURL(url)
    }
    
    private func viewControllerForDeepLinkURL(_ url: URL) {
        if url.scheme != deepLinkURLSchema {
            handleInvalidDeepLinkURL(message: "Invalid URL Schema was Passed")
            return
        }
        guard isLoggedIn else {
            setRootViewController(LoginViewController())
            handleInvalidDeepLinkURL(message: "Please login to continue")
            return
        }
        guard let host = url.host else {
            handleInvalidDeepLinkURL(message: "URL host is Missing")
            return
        }
        if validHosts.contains(host) {
            switch host {
            case "chat":
                if let message = getValue(forParameter: "message", fromURL: url) {
                    let mainVC = MainViewController(message: message)
                    mainVC.selectedIndex = 0
                    setRootViewController(mainVC)
                } else {
                    handleInvalidDeepLinkURL(message: "Invalid URL Schema")
                }
            case "contact":
                if let contact = getValue(forParameter: "contact", fromURL: url),
                   let mobile = getValue(forParameter: "mobile", fromURL: url) {
                    let mainVC = MainViewController(contact: contact, mobile: mobile)
                    mainVC.selectedIndex = 1
                    setRootViewController(mainVC)
                } else {
                    handleInvalidDeepLinkURL(message: "Invalid URL Schema")
                }
            case "settings":
                let mainVC = MainViewController()
                mainVC.selectedIndex = 2
                setRootViewController(mainVC)
            default:
                break
            }
        } else {
            handleInvalidDeepLinkURL(message: "Invalid URL Host")
        }
    }
    
    private func getValue(forParameter parameter: String, fromURL url: URL) -> String? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            handleInvalidDeepLinkURL(message: "Component Not Found")
            return nil
        }
        return components.queryItems?.first(where: { $0.name == parameter })?.value
    }
    
    private func setRootViewController(_ viewController: UIViewController) {
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
    
    private func handleInvalidDeepLinkURL(message: String) {
        let alertController = UIAlertController(title: "Error",
                                                message: message,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
