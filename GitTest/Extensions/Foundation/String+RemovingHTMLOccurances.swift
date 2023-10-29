//
//  String+RemovingHTMLOccurances.swift
//  CryptoApp
//
//  Created by Tam Nguyen on 09/07/2021.
//

extension String {
    
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
}
