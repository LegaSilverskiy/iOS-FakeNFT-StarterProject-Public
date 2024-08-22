//
//  String+Extension.swift
//  FakeNFT
//
//  Created by Олег Серебрянский on 8/22/24.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        let firstLetter = prefix(1).uppercased()
        let restOfString = dropFirst(1).lowercased()
        return firstLetter + restOfString
    }
    mutating func capitalizeFirstLetter() {
            self = self.capitalizingFirstLetter()
        }
}
