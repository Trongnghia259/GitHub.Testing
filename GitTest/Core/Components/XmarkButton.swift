//
//  XmarkButton.swift
//  CryptoApp
//
//  Created by Tam Nguyen on 08/07/2021.
//

import SwiftUI

struct XmarkButton: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "xmark")
                .font(.headline)
        })
    }
    
}

struct XmarkButton_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            XmarkButton()
                .previewLayout(.sizeThatFits)
            
            XmarkButton()
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
    
}
