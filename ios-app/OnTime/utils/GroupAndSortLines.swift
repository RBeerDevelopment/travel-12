//
//  groupAndSortLines.swift
//  OnTime - Transit
//
//  Created by Robin Beer on 29.07.25.
//

import Foundation

let MAX_CHARACTER_PER_LINE = 42

var CACHE: [Int: [[StationSearchItemLine]]] = [:]

func splitIntoChunks<T>(array: [T], chunkCount: Int) -> [[T]] {
    guard chunkCount > 0 else { return [] }

    let totalCount = array.count
    let baseChunkSize = totalCount / chunkCount

    // If the total count is less than x, each element goes into its own chunk until done
    if totalCount <= chunkCount {
        return array.map { [$0] }
    }

    var result: [[T]] = []
    var startIndex = 0

    for i in 0..<chunkCount {
        // Give an extra item to first (x - 1) chunks, if there's a remainder
        let endIndex: Int
        if i < chunkCount - 1 {
            endIndex = startIndex + baseChunkSize
        } else {
            endIndex = array.count // Last chunk takes the rest
        }

        let chunk = Array(array[startIndex..<endIndex])
        result.append(chunk)
        startIndex = endIndex
    }

    return result
}


func groupAndSortLines(_ lines: [StationSearchItemLine]) -> [[StationSearchItemLine]] {
    
    let hash = lines.hashValue
    if(CACHE.keys.contains(hash)) {
        return CACHE[hash]!
    }

    let groupedLines = Dictionary(grouping: lines, by: { $0.product })
    
    var groupedAndSortedLines: [[StationSearchItemLine]] = []
        
    groupedLines.values.forEach { linesForProduct in
        let initialResult = Array(linesForProduct).sorted { $0.name < $1.name }
        
        // calculate o
        let resultLength = initialResult.reduce(0) { result, line in
            // add 6 to include calculate of the spacing around and inside each line indicator
            return result + line.name.count + 6
        }
        
        if(resultLength <= MAX_CHARACTER_PER_LINE) {
            groupedAndSortedLines.append(initialResult)
            return
        }
        
        let numberOfChunks = Int(ceil(Double(resultLength) / Double(MAX_CHARACTER_PER_LINE)))
        
        let splitResult = splitIntoChunks(array: initialResult, chunkCount: numberOfChunks)
        
        groupedAndSortedLines.append(contentsOf: splitResult)
    }
    
    CACHE[hash] = groupedAndSortedLines
    
    return groupedAndSortedLines
}
