//
//  CatalogViewController + TableView.swift
//  FakeNFT
//
//  Created by Олег Серебрянский on 8/7/24.
//

import UIKit

extension CatalogViewController: UITableViewDataSource {
    //TODO: Сделать расчет колличества ячеек после получения доступа к АПИ
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    //TODO: Заполнить данными после получения АПИ
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellForTableInCatalog.identiferForCellInTableView, for: indexPath) as? CellForTableInCatalog else {
            print("We have some problems with CustomCell")
            
            return UITableViewCell()
        }
        return cell
    }
}

extension CatalogViewController: UITableViewDelegate {
        //TODO: Сделать переход по нажатию
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
    }
    
}
