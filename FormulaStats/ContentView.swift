//
//  ContentView.swift
//  FormulaStats
//
//  Created by Jacob Seiberg on 10/22/24.
//

import SwiftUI

struct ContentView: View {
    @State private var firstName = ""
    @State private var firstYear = ""
    @State private var secondName = ""
    @State private var secondYear = ""
    
    // Data points placeholders for demonstration
    @State private var firstDataPoints: [String] = ["Data 1", "Data 2", "Data 3", "Data 4"]
    @State private var secondDataPoints: [String] = ["Data 1", "Data 2", "Data 3", "Data 4"]
    
    var body: some View {
        VStack(spacing: 20) {
            // First Name and Year
            VStack(alignment: .leading, spacing: 10) {
                Text("Input First Drivers Name and Season")
                    .font(.headline)
                
                HStack {
                    TextField("Enter first name", text: $firstName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Year", text: $firstYear)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 80)
                }
                
                // Still need to change this to not display via a loop so I can actually write the data points I need. or just make an array with the diffent data categories
                ForEach(firstDataPoints.indices, id: \.self) { index in
                    Text("Data Point \(index + 1): \(firstDataPoints[index])")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
            
            Divider()
            
            // Second Name and Year
            VStack(alignment: .leading, spacing: 10) {
                Text("Second Name and Year")
                    .font(.headline)
                
                HStack {
                    TextField("Enter second name", text: $secondName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Enter year", text: $secondYear)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 80)
                }
                
                // Same as above need to change to actually display the correct data points
                ForEach(secondDataPoints.indices, id: \.self) { index in
                    Text("Data Point \(index + 1): \(secondDataPoints[index])")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
            
            Spacer()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
