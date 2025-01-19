//
//  CombineApiHelper.swift
//  Travel12
//
//  Created by Robin Beer on 24.11.24.
//

import Combine
import SwiftUI

class CombineApiHelper {
    private let urlSession = URLSession.shared
    private var cancellables = Set<AnyCancellable>()
    private let decoder = JSONDecoder()
    
    func fetchApiDataIntoCombine<T: Decodable>(from urlString: String,
                                 to decodingType: T.Type,
                                 onReceive: @escaping () -> Void,
                                 responseHandler: @escaping (T) -> Void,
                                 dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601) throws {
        decoder.dateDecodingStrategy = dateDecodingStrategy
        
        guard let url = URL(string: urlString)
        else {
            throw "Error creating URL from \(urlString)"
        }
        
        urlSession.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: decodingType, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                onReceive()
                switch completion {
                case .finished:
                    print("Request completed successfully")
                case .failure(let error):
                    print("Error fetching from \(urlString): \(error.localizedDescription)")
                }
            }, receiveValue: { request in responseHandler(request) })
            .store(in: &cancellables)
        
    }
}

