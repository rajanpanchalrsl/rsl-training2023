import Foundation

class CharacterNetworkManager {
    
    var characters: [Character] = []
    private let charactersAPIEndpoint = "https://thronesapi.com/api/v2/Characters"

    func getCharacters(completion: @escaping ([Character]?, Error?) -> Void) {
        guard let url = URL(string: charactersAPIEndpoint) else {
            completion(nil, NSError(domain: "Invalid API Endpoint", code: 0, userInfo: nil))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let data = data else {
                completion(nil, NSError(domain: "No Data Received", code: 0, userInfo: nil))
                return
            }
            do {
                let decoder = JSONDecoder()
                let characters = try decoder.decode([Character].self, from: data)
                self.characters = characters
                completion(characters, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    func postCharacter(_ character: Character, completion: @escaping (Bool, Error?) -> Void) {
        guard let url = URL(string: charactersAPIEndpoint) else {
            completion(false, NSError(domain: "Invalid API Endpoint", code: 0, userInfo: nil))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(character)
            request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(false, error)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    let error = NSError(domain: "Invalid HTTP Response", code: 0, userInfo: nil)
                    completion(false, error)
                    return
                }
                if httpResponse.statusCode == 200 {
                    completion(true, error)
                    return
                }
                let error = NSError(domain: "HTTP Error", code: httpResponse.statusCode, userInfo: nil)
                completion(false, error)
            }
            task.resume()
        } catch {
            completion(false, error)
        }
    }
}
