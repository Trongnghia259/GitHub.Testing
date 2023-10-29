//
//  URLSession+DataTaskPublisher.swift
//  CryptoApp
//
//  Created by Tam Nguyen on 07/07/2021.
//

import Foundation
import Combine

extension URLSession {
    
    func dataTaskPublisher<T: Decodable>(with urlString: String, decoder: JSONDecoder = .init()) -> AnyPublisher<T, Error> {
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        return dataTaskPublisher(for: url)
            .map(\.data)
            .receive(on: DispatchQueue.main)
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
}
