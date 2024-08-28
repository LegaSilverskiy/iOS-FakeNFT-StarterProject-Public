import Foundation


final class NftStorage {
    
    var likes: Set<String> = []
    var orders: Set<String> = []
    var orderId: String?
    
    private var storage: [String: Nft] = [:]
    private let syncQueue = DispatchQueue(label: "sync-nft-queue")
    
    func saveNft(_ nft: Nft) {
        syncQueue.async { [weak self] in
            self?.storage[nft.id] = nft
        }
    }
    
    func getNft(with id: String) -> Nft? {
        syncQueue.sync {
            storage[id]
        }
    }
    
    func getLike(with id: String) -> String? {
        return syncQueue.sync {
            likes.first(where: {$0 == id})
        }
    }
    
    func saveLike(_ nft: String) {
        syncQueue.async { [weak self] in
            self?.likes.insert(nft)
        }
    }
    
    func deleteLike(with id: String) {
        syncQueue.async { [weak self] in
            self?.likes.remove(id)
        }
    }
    
    func saveOrderId(orderId: String){
        syncQueue.async { [weak self] in
            self?.orderId = orderId
        }
    }
    
    func saveOrders(_ nft: String) {
        syncQueue.async { [weak self] in
            self?.orders.insert(nft)
        }
    }
    
    func findInOrders(_ nft: String) -> Bool {
        orders.contains(nft)
    }
    
    func deleteOrders(with id: String) {
        syncQueue.async { [weak self] in
            self?.orders.remove(id)
        }
    }
}
