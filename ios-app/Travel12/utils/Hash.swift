//
//  Hash.swift
//  Travel12
//
//  Created by Robin Beer on 10.11.24.
//

import CryptoKit
import Foundation

func hashStringToMaxLength(_ input: String, maxLength: Int = 24) -> String {
    // Ensure maxLength is within a valid range
    let effectiveLength = max(1, min(maxLength, 64))
    
    // Generate the SHA-256 hash of the input string
    let inputData = Data(input.utf8)
    let hash = SHA256.hash(data: inputData)
    
    // Convert the hash to a hexadecimal string
    let hashString = hash.compactMap { String(format: "%02x", $0) }.joined()
    
    // Truncate to the desired length
    return String(hashString.prefix(effectiveLength))
}
