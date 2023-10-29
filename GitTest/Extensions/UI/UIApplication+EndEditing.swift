//
//  UIApplication+EndEditing.swift
//  CryptoApp
//
//  Created by Tam Nguyen on 08/07/2021.
//

import SwiftUI

extension UIApplication {
    
    func endEditting() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
