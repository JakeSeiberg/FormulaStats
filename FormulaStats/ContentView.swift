//
//  ContentView.swift
//  FormulaStats
//
//  Created by Jacob Seiberg on 10/22/24.
//

import SwiftUI

struct ContentView: View {
    @State private var input = ""
    var body: some View {
        VStack {
            TextField("Input a year", text: $input)
            Text("The year you chose is: " + input)
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
