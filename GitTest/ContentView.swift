//
//  ContentView.swift
//  GitTest
//
//  Created by Tam Nguyen on 23/10/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Image(systemName: "home.fill")
                .imageScale(.large)
                .foregroundStyle(.blue)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
