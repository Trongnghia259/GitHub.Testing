//
//  CircleAnimationButtonView.swift
//  CryptoApp
//
//  Created by Tam Nguyen on 06/07/2021.
//

import SwiftUI

struct CircleAnimationButtonView: View {
    
    @Binding var animate: Bool
    
    var body: some View {
        Circle()
            .stroke(lineWidth: 1)
            .scaleEffect(animate ? 1 : 0.01)
            .opacity(animate ? 0 : 1)
            .animation(animate ? Animation.easeOut(duration: 1) : .none)
    }
    
}

struct CircleAnimationButtonView_Previews: PreviewProvider {
    
    static var previews: some View {
        CircleAnimationButtonView(animate: .constant(true))
            .foregroundColor(.nagative)
            .frame(width: 100, height: 100)
    }
    
}
