//
//  AnyPublisher+Result.swift
//  CryptoApp
//
//  Created by Tam Nguyen on 07/07/2021.
//

import Combine

extension AnyPublisher {
    
    static func just(_ output: Output) -> Self {
        Just(output)
            .setFailureType(to: Failure.self)
            .eraseToAnyPublisher()
    }
    
    static func fail(with error: Failure) -> Self {
        Fail(error: error).eraseToAnyPublisher()
    }
    
}
