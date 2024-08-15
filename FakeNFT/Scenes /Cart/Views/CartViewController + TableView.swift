import UIKit

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.getNftsCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.reuseIdentifier, for: indexPath) as? CartTableViewCell else { return UITableViewCell()
        }
        
        guard let cartNftModel = presenter?.getNft(at: indexPath) else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        cell.selectionStyle = .none
        cell.configCell(with: cartNftModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
}
