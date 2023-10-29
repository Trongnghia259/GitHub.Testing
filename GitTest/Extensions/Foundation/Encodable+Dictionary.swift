//
//  Encodable+Dictionary.swift
//  CryptoApp
//
//  Created by Tam Nguyen on 07/07/2021.
//

import Foundation

extension Encodable {
    
    var asDictionary: [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else { return [:] }
        
        guard let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            return [:]
        }
        return dictionary
    }
    
}
