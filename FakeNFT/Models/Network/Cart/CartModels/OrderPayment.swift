import Foundation

struct OrderPayment: Decodable {
    let success: Bool
    let orderId: String
    let id: String
}
