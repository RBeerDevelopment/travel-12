//
//  KeychainHelper.swift
//  OnTime
//
//  Created by Robin Beer on 10.11.24.
//

import Security
import Foundation

func storeValueToKeychain(key: String, value: String) {
    let keychainItem: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: key,
        kSecValueData as String: value.data(using: .utf8)!
    ]
    
    SecItemDelete(keychainItem as CFDictionary) // Remove existing item if it exists
    SecItemAdd(keychainItem as CFDictionary, nil)
}

func retrieveValueFromKeychain(key: String) -> String? {
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: key,
        kSecReturnData as String: true
    ]
    
    var item: CFTypeRef?
    if SecItemCopyMatching(query as CFDictionary, &item) == errSecSuccess,
       let data = item as? Data,
       let value = String(data: data, encoding: .utf8) {
        return value
    }
    return nil
}

func deleteValueFromKeychain(key: String) {
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: key
    ]
    
    SecItemDelete(query as CFDictionary)
}
