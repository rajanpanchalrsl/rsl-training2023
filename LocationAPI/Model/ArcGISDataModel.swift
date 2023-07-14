import Foundation

struct ArcGISDataModel: Codable {
    let features: [University]
}

struct University: Codable {
    let attributes: Attributes
    let geometry: Geometry
}

struct Attributes: Codable {
    let objectid: Int
    let universityChapter: String
    let city: String
    let state: String
    let chapterID: String?
    let mevrRD: String
    
    enum CodingKeys: String, CodingKey {
        case objectid = "OBJECTID"
        case universityChapter = "University_Chapter"
        case city = "City"
        case state = "State"
        case chapterID = "ChapterID"
        case mevrRD = "MEVR_RD"
    }
}

struct Geometry: Codable {
    let x: Double
    let y: Double
}
