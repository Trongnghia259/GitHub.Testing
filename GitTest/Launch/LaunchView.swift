//
//  LaunchView.swift
//  CryptoApp
//
//  Created by Tam Nguyen on 10/07/2021.
//

import SwiftUI

struct LaunchView: View {
    
    @State private var counter: Int = 0
    @State private var loops: Int = 0
    @Binding var isShowingLaunchView: Bool
    
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            Image("logo-transparent")
                .renderingMode(.template)
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.accent)
            
            ZStack {
                HStack(spacing: 0) {
                    Text("Loading")
                        .font(.headline)
                        .fontWeight(.heavy)
                        .foregroundColor(.accent)
                    ForEach([0, 1, 2].indices) { index in
                        Text(".")
                            .font(.headline)
                            .fontWeight(.heavy)
                            .foregroundColor(.accent)
                            .offset(y: counter == index ? -5 : 0)
                    }
                }
                .transition(AnyTransition.scale.animation(.easeIn))
            }
            .offset(y: 70)
        }
        .onReceive(timer, perform: { _ in
            withAnimation(.spring()) {
                if counter == 2 {
                    counter = 0
                    loops += 1
                    if loops > 5 {
                        isShowingLaunchView = false
                    }
                } else {
                    counter += 1
                }
            }
        })
    }
    
}

struct LaunchView_Previews: PreviewProvider {
    
    static var previews: some View {
        LaunchView(isShowingLaunchView: .constant(true))
    }
    
}
