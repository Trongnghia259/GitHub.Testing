//
//  CircleButtonView.swift
//  CryptoApp
//
//  Created by Tam Nguyen on 06/07/2021.
//

import SwiftUI

struct CircleButtonView: View {
    
    let iconName: String
    
    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundColor(.accent)
            .frame(width: 50, height: 50)
            .background(
                Circle()
                    .foregroundColor(.background)
                    .shadow(color: .accent.opacity(0.15), radius: 10)
            )
            .padding()
    }
    
}

struct CircleButtonView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            CircleButtonView(iconName: "plus")
                .padding()
                .previewLayout(.sizeThatFits)
            
            CircleButtonView(iconName: "info")
                .padding()
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
    
}
