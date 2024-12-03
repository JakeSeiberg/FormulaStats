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
    
    @FocusState private var focusYear1: Bool
    @FocusState private var focusYear2: Bool
    
    @State private var firstDriverID: String = ""
    @State private var secondDriverID: String = ""
    
    @State private var firstDriverList: [String] = []
    @State private var secondDriverList: [String] = []
    
    @State private var firstDriverWins: Int = -1
    @State private var secondDriverWins: Int = -1
    
    @State private var firstDriverPts: Float = -1
    @State private var secondDriverPts: Float = -1
    
    @State private var firstDriverPos : Int = -1
    @State private var secondDriverPos : Int = -1
  
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
                        .focused($focusYear1)
                    Button("Get Drivers") {
                        focusYear1 = false
                        focusYear2 = false
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
                        .focused($focusYear2)
                    Button("Get Drivers") {
                        focusYear1 = false
                        focusYear2 = false
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
            
            
                
            if secondName != "" && firstName != "" {
                
                Button("Get Race Data") {
                    let driverOneF = splitName(firstName).0
                    let driverOneL = splitName(firstName).1
                    
                    let driverTwoF = splitName(secondName).0
                    let driverTwoL = splitName(secondName).1
                    
                    var firstRaces = 0
                    var secondRaces = 0
                    
                    //this gives warning but still works, working on clearing it
                    var timer: Timer?
                    var count: Int = 0
                    //gets the two driverIDs
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
                    
                    //gets total number of races in season for both drivers
                    getRacesInSeason(season: secondYear, driverId: secondDriverID){ ttlRaces in
                        if let ttlRaces = ttlRaces{
                            secondRaces = ttlRaces
                        }else{
                            print("error fetching total races")
                        }
                    }
                    getRacesInSeason(season: firstYear, driverId: firstDriverID){ ttlRaces in
                        if let ttlRaces = ttlRaces{
                            firstRaces = ttlRaces
                        }else{
                            print("error fetching total races")
                        }
                    }
                    
                    //first driver data
                    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){timer in
                        getDriverWins(season: firstYear, driverId: firstDriverID){ wins in
                            if let wins = wins {
                                firstDriverWins = wins
                            } else {
                                print("Driver not found")
                            }
                        }
                        getPointsInSeason(season: firstYear, driverID: firstDriverID){ pts in
                            if let pts = pts {
                                firstDriverPts = pts
                            } else {
                                print("Driver not found")
                            }
                        }
                        if firstDriverWins != firstRaces || count > 4{
                            timer.invalidate()
                        }
                        else{
                            count += 1
                        }
                    }
                    
                    count = 0
                    
                    //second driver data
                    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){timer in
                        getDriverWins(season: secondYear, driverId: secondDriverID){ wins in
                            if let wins = wins {
                                secondDriverWins = wins
                            } else {
                                print("Driver not found")
                            }
                        }
                        getPointsInSeason(season: secondYear, driverID: secondDriverID){ pts in
                            if let pts = pts {
                                secondDriverPts = pts
                            }
                            else{
                                print("Driver not found")
                            }
                        }
                        //get final standings data for both drivers
                        getFinalPositionInSeason(season: firstYear, driverID: firstDriverID){pos in
                            if let pos = pos {
                                firstDriverPos = pos
                            }
                            else{
                                print("Driver not found")
                            }
                        }
                        getFinalPositionInSeason(season: secondYear, driverID: secondDriverID){pos in
                            if let pos = pos {
                                secondDriverPos = pos
                            }
                            else{
                                print("Driver not found")
                            }
                        }
                        
                        if secondDriverWins != secondRaces || count > 4{
                            timer.invalidate()
                        }
                        else{
                            count += 1
                        }
                    }

                }
                
            }
           
            
            VStack(){ //eventually make this a button that takes to a navigation so this looks better...maybe...low priority
                if firstDriverWins != -1 && secondDriverWins != -1 && firstDriverPts != -1 && secondDriverPts != -1{
                    
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
                        Text("Points: \(String(format: "%g",firstDriverPts))")
                        Spacer()
                        Text("Points: \(String(format: "%g",secondDriverPts))")
                        Spacer()
                    }
                    Spacer()
                    HStack{
                        Spacer()
                        Text("Drivers Standings: \(firstDriverPos)")
                        Spacer()
                        Text("Drivers Standings: \(secondDriverPos)")
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
                else{
                    Text("Waiting for data...")
                        .font(.headline)
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
