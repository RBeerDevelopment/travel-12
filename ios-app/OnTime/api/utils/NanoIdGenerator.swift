//
//  NanoIdGenerator.swift
//  OnTime
//
//  Created by Robin Beer on 16.02.25.
//

func generateNanoId(size: Int = 21) -> String {
    let alphabet = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-_"
    var result = ""
    
    for _ in 0..<size {
        let randomIndex = Int.random(in: 0..<alphabet.count)
        let index = alphabet.index(alphabet.startIndex, offsetBy: randomIndex)
        result.append(alphabet[index])
    }
    
    return result
}
