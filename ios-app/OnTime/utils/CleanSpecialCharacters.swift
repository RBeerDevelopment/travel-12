//
//  CleanSpecialCharacters.swift
//  OnTime
//
//  Created by Robin Beer on 22.11.24.
//

extension String {
    func cleanUmlauts() -> String {
        return self.lowercased()
            .replacingOccurrences(of: "ä", with: "ae")
            .replacingOccurrences(of: "ö", with: "oe")
            .replacingOccurrences(of: "ü", with: "ue")
            .replacingOccurrences(of: "ß", with: "ss")
    }
}
