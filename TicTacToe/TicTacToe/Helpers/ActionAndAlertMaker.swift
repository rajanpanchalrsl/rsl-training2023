import UIKit

class ActionAndAlertMaker: UIViewController {
    
    private static func getRootViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return nil
        }
        return windowScene.windows.first?.rootViewController
    }
    
    static func showActionSheet<T: RawRepresentable>(title: String, options: [T], completion: @escaping (T) -> Void) {
        guard let rootViewController = getRootViewController() else {
            return
        }
        let actionSheet = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        for option in options {
            let action = UIAlertAction(title: option.rawValue as? String, style: .default) { _ in
                completion(option)
            }
            actionSheet.addAction(action)
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        rootViewController.present(actionSheet, animated: true, completion: nil)
    }
    
    static func showAlert(title: String, subtitle: String? = nil) {
        guard let rootViewController = getRootViewController() else {
            return
        }
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        rootViewController.present(alert, animated: true, completion: nil)
    }
    
    static func showAlertWithAction(title: String, message: String, actionTitle: String, actionHandler: @escaping () -> Void) {
        guard let rootViewController = getRootViewController() else {
            return
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default) { _ in
            actionHandler()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(action)
        alertController.addAction(cancelAction)
        rootViewController.present(alertController, animated: true, completion: nil)
    }
}

