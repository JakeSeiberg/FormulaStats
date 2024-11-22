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
    
    @State private var firstDriverID: String = ""
    @State private var secondDriverID: String = ""
    
    @State private var firstDriverList: [String] = []
    @State private var secondDriverList: [String] = []
    
    @State private var firstDriverWins: Int = -1
    @State private var secondDriverWins: Int = -1
  
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
            
            //need to ping twice for some reason. TODO: fix this bug
            if secondName != "" && firstName != "" {
                Button("Get Race Data") {
                    let driverOneF = splitName(firstName).0
                    let driverOneL = splitName(firstName).1
                    let driverTwoF = splitName(secondName).0
                    let driverTwoL = splitName(secondName).1
                    
                    getDriverId(season: firstYear, givenName: driverOneF, familyName: driverOneL) { driverId in
                        if let driverId = driverId {
                            firstDriverID = driverId
                        } else {
                            print("Driver not found")
                        }
                    }
                    getDriverId(season: secondYear, givenName: driverTwoF, familyName: driverTwoL) { driverId in
                        if let driverId = driverId {
                            secondDriverID = driverId
                        } else {
                            print("Driver not found")
                        }
                    }
                    
                    getDriverWins(season: firstYear, driverId: firstDriverID){ wins in
                        if let wins = wins {
                            firstDriverWins = wins
                        } else {
                            print("Driver not found")
                        }
                    }
                    getDriverWins(season: secondYear, driverId: secondDriverID){ wins in
                        if let wins = wins {
                            secondDriverWins = wins
                        } else {
                            print("Driver not found")
                        }
                    }
                    
                }
                
            }
            
            VStack(){ //eventually make this a button that takes to a navigation so this looks better...maybe...low priority
                if firstDriverWins != -1 && secondDriverWins != -1{
                    
                    ViewThatFits{
                        Text("\(firstYear) \(firstName) V.S. \(secondYear) \(secondName)")
                            .font(.subheadline)
                            .lineLimit(1)
                            .padding()
                    }
                    HStack{
                        Spacer()
                        Text("Wins: \(firstDriverWins)")
                        Spacer()
                        Text("Wins: \(secondDriverWins)")
                        Spacer()
                    }
                    Spacer()
                    HStack{
                        Spacer()
                        Text("Points:")
                        Spacer()
                        Text("Points:")
                        Spacer()
                    }
                    Spacer()
                    HStack{
                        Spacer()
                        Text("Drivers Standings:")
                        Spacer()
                        Text("Drivers Standings:")
                        Spacer()
                    }
                    Spacer()
                    HStack{
                        Spacer()
                        Text("Pole Positions:")
                        Spacer()
                        Text("Pole Positions:")
                        Spacer()
                    }
                }
            }
            Spacer()
        }
    }
            
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
