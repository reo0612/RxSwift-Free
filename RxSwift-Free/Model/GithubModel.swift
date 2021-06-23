
import Foundation

struct GithubResponce: Codable {
    let items: [GithubModel]
}

struct GithubModel: Codable {
    var name: String
    var htmlUrl: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case htmlUrl = "html_url"
    }
}
