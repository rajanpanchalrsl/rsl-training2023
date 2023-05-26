import Foundation
import UIKit

class ImageNetworkManager: NSObject {

    var imageCompletion: ((UIImage?, Error?) -> Void)?

    func getImage(of character: Character,
                  completion: @escaping (UIImage?, Error?) -> Void) {
        let urlString = character.imageUrl
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "Invalid API Endpoint", code: 0, userInfo: nil)
            completion(nil, error)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let data = data else {
                let error = NSError(domain: "No Image Found", code: 0, userInfo: nil)
                completion(nil, error)
                return
            }
            guard let image = UIImage(data: data) else {
                let error = NSError(domain: "Invalid Image Data", code: 0, userInfo: nil)
                completion(nil, error)
                return
            }
            completion(image, nil)
        }
        task.resume()
    }
    
    /*
     To verify downloading working even in background
     A heavy size image URL is to be used (3MB), Change urlString to below URL
     let urlString = "https://i.ibb.co/m4ZwdMc/eduardo-bergen-a1-V5i-A9-UTDc-unsplash.jpg"
     */
    private func downloadImage(of character: Character, completion: @escaping (UIImage?, Error?) -> Void) {
        let urlString = character.imageUrl
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "Invalid API Endpoint", code: 0, userInfo: nil)
            completion(nil, error)
            return
        }
        imageCompletion = completion
        let task = urlSession.downloadTask(with: url)
        task.resume()
    }

    func saveImage(of character: Character,
                   completion: @escaping (Bool, Error?) -> Void) {
        self.downloadImage(of: character) { image, error in
            if let error = error {
                completion(false, error)
            }
            guard let image = image else {
                let error = NSError(domain: "Image Not Found", code: 0, userInfo: nil)
                completion(false, error)
                return
            }
            DispatchQueue.main.async {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                completion(true, nil)

            }
        }
    }

    private lazy var urlSession: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: "backgroundDownloading")
        config.isDiscretionary = true
        config.sessionSendsLaunchEvents = true
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
}

extension ImageNetworkManager: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        guard let data = try? Data(contentsOf: location),
              let image = UIImage(data: data) else {
            let error = NSError(domain: "Invalid Image Data", code: 0, userInfo: nil)
            self.imageCompletion?(nil, error)
            return
        }
        self.imageCompletion?(image, nil)
    }

    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                  let backgroundCompletionHandler = appDelegate.backgroundCompletionHandler else {
                return
            }
            print("Background Session Completed")
            backgroundCompletionHandler()
        }
    }
}
