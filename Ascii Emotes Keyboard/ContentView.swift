//
//  ContentView.swift
//  Ascii Emotes Keyboard
//
//  Created by Kali Francia on 3/11/24.
//

import SwiftUI

struct ContentView: View {
    @State private var textTesting: String = ""

    var body: some View {
        VStack {
             Image(systemName: "globe")
                 .imageScale(.large)
                 .foregroundStyle(.tint)
             Text("Hello, world!")
             
             // Keyboard Debugging
             TextField("Test Here", text: $textTesting)
         }
         .padding()
     }
}

#Preview {
    ContentView()
}
