//
//  View.swift
//  GitTest
//
//  Created by Tam Nguyen on 25/10/2023.
//

import SwiftUI

struct CoinLogoView: View {
    
    
    var body: some View {
        VStack {
            Image("Image")
                .resizable()
            .frame(width: 300, height: 300)
            Text("Hello Word")
                .font(.headline)
                .foregroundColor(.blue)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("Hello Agian")
                .font(.caption)
                .foregroundColor(.red)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
        }
    }
    
}

struct CoinLogoView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            CoinLogoView()
                .previewLayout(.sizeThatFits)
        }
    }
    
}
