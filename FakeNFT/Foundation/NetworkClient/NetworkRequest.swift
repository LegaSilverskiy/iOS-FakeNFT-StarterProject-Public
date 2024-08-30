import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol NetworkRequest {
    var endpoint: URL? { get }
    var httpMethod: HttpMethod { get }
    var dto: Encodable? { get }
    var body: Data? { get } // TODO: - убрать дублирующийся код
    var dtoEncoded: Data? {get } // TODO: - убрать дублирующийся код
}

// default values
extension NetworkRequest {
    var httpMethod: HttpMethod { .get }
    var dto: Encodable? { nil }
    var body: Data? { nil } // TODO: - убрать дублирующийся код
    var dtoEncoded: Data? { nil } // TODO: - убрать дублирующийся код
}
