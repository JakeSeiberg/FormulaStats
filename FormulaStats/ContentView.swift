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
    
    @State private var firstDriverList: [String] = []
    @State private var secondDriverList: [String] = []
    
    // Data points placeholders for demonstration
    @State private var firstDataPoints: [String] = ["Data 1", "Data 2", "Data 3", "Data 4"]
    @State private var secondDataPoints: [String] = ["Data 1", "Data 2", "Data 3", "Data 4"]
    
    var body: some View {
        
        VStack(spacing: 20) {
            // First Name and Year
            VStack(alignment: .leading, spacing: 10) {
                Text("   Input First Drivers Season and Name   ")
                    .font(.headline)
                
                HStack {
                    TextField("Year", text: $firstYear)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 80)
                    Button("Get Drivers") {
                        getDriversList(season: firstYear) { drivers in
                            if let drivers = drivers {
                                firstDriverList = drivers
                            } else {
                                print("Failed to fetch drivers")
                            }
                        }
                    }
                    if firstDriverList.isEmpty {
                        Text("Loading...")
                    }
                    else{
                        Picker(selection: $firstName, label: Text("Pick")) {
        
                            ForEach(firstDriverList, id: \.self) { driver in
                                    Text(driver)
                                }
                            }
                        }
                    }
                
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            Divider()
            
            // Second Name and Year
            VStack(alignment: .leading, spacing: 10) {
                Text("Input Second Drivers Season and Name")
                    .font(.headline)
                
                HStack {
                    TextField("Year", text: $secondYear)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 80)
                    Button("Get Drivers") {
                        getDriversList(season: secondYear) { drivers in
                            if let drivers = drivers {
                                secondDriverList = drivers
                            } else {
                                print("Failed to fetch drivers")
                            }
                        }
                    }
                    if secondDriverList.isEmpty {
                        Text("Loading...")
                    }
                    else{
                        Picker(selection: $secondName, label: Text("Pick")) {
                            ForEach(secondDriverList, id: \.self) { driver in
                                Text(driver)
                            }
                        }
                    }
                    
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
            
            VStack(){ //eventually make this a button that takes to a navigation so this looks better
                ViewThatFits{
                    Text("\(firstYear) \(firstName) V.S. \(secondYear) \(secondName)")
                        .font(.subheadline)
                        .lineLimit(1)
                        .padding()
                }
                HStack{
                    Spacer()
                    Text("\(firstDataPoints[0])")
                    Spacer()
                    Text("\(secondDataPoints[0])")
                    Spacer()
                }
                Spacer()
                HStack{
                    Spacer()
                    Text("\(firstDataPoints[1])")
                    Spacer()
                    Text("\(secondDataPoints[1])")
                    Spacer()
                }
                Spacer()
                HStack{
                    Spacer()
                    Text("\(firstDataPoints[2])")
                    Spacer()
                    Text("\(secondDataPoints[2])")
                    Spacer()
                }
                Spacer()
                HStack{
                    Spacer()
                    Text("\(firstDataPoints[3])")
                    Spacer()
                    Text("\(secondDataPoints[3])")
                    Spacer()
                }
            }
            
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
