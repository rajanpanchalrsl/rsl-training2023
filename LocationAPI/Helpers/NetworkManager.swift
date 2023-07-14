import Foundation

class NetworkManager {
    
    private let apiEndpoint = "https://services2.arcgis.com/5I7u4SJE1vUr79JC/arcgis/rest/services/UniversityChapters_Public/FeatureServer/0/query?where=1%3D1&outFields=*&outSR=4326&f=json"
    
    func getUniversities(completion: @escaping ([University]?, Error?) -> Void) {
        guard let url = URL(string: apiEndpoint) else {
            let error = NSError(domain: "Invalid API Endpoint", code: 0, userInfo: nil)
            completion(nil, error)
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                let error = NSError(domain: "Invalid Server Response", code: 0, userInfo: nil)
                completion(nil, error)
                return
            }
            do {
                let decoder = JSONDecoder()
                let arcgisData = try decoder.decode(ArcGISDataModel.self, from: data!)
                let universitiesArray = arcgisData.features
                completion(universitiesArray, nil)
            } catch {
                let error = NSError(domain: "Network Error", code: 0, userInfo: nil)
                completion(nil, error)
            }
        }.resume()
    }
}
