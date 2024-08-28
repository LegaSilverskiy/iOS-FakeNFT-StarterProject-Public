import Foundation


final class NftStorage {
    
    private var likes: Set<String> = []
    private var orders: Set<String> = []
    var orderId: String?
    
    private var storage: [String: Nft] = [:]
    private let storageQueue = DispatchQueue(label: "storage-nft-queue")
    
    func saveNft(_ nft: Nft) {
        storageQueue.async { [weak self] in
            self?.storage[nft.id] = nft
        }
    }
    
    func getNft(with id: String) -> Nft? {
        storageQueue.sync {
            storage[id]
        }
    }
    
    func getLike(with id: String) -> String? {
        return storageQueue.sync {
            likes.first(where: {$0 == id})
        }
    }
    
    func saveLike(_ nft: String) {
        storageQueue.async { [weak self] in
            self?.likes.insert(nft)
        }
    }
    
    func deleteLike(with id: String) {
        storageQueue.async { [weak self] in
            self?.likes.remove(id)
        }
    }
    
    func saveOrderId(orderId: String){
        storageQueue.async { [weak self] in
            self?.orderId = orderId
        }
    }
    
    func saveOrders(_ nft: String) {
        storageQueue.async { [weak self] in
            self?.orders.insert(nft)
        }
    }
    
    func findInOrders(_ nft: String) -> Bool {
        orders.contains(nft)
    }
    
    func deleteOrders(with id: String) {
        storageQueue.async { [weak self] in
            self?.orders.remove(id)
        }
    }
}
