import Foundation

struct GetNFTByIDRequest: NetworkRequest {
    let end: String
    
    var endpoint: URL? {
        return URL(string: "\(RequestConstants.baseURL)/api/v1/\(end)")
    }
    var httpMethod: HttpMethod { .get }
    var dto: Encodable? { nil }
}

