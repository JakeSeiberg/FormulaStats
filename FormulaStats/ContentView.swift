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
    
    @State private var ttlRacesOne: Int = 0
    @State private var ttlRacesTwo: Int = 0
    
    
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
    
    @State private var firstDriverPoles: String = ""
    @State private var secondDriverPoles: String = ""
      
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
                            ttlRacesTwo = ttlRaces
                        }else{
                            print("error fetching total races")
                        }
                    }
                    getRacesInSeason(season: firstYear, driverId: firstDriverID){ ttlRaces in
                        if let ttlRaces = ttlRaces{
                            ttlRacesOne = ttlRaces
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
                        if firstDriverWins != ttlRacesOne || count > 4{
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
                        
                        //get poles if year is 2003 and beyond
                        let intFirstYear = Int(firstYear) ?? 0
                        let intSecondYear = Int(secondYear) ?? 0
                        
                        if intFirstYear >= 2003{
                            
                            getDriverPoles(season: firstYear, driverId: firstDriverID){ poles in
                                if let poles = poles {
                                    firstDriverPoles = String(poles)
                                }
                                else{
                                    print("Driver not found")
                                }
                            }
                        }
                        else{
                            firstDriverPoles = "No pole data from before 2003"
                        }
                        if intSecondYear >= 2003{
                            
                            getDriverPoles(season: secondYear, driverId: secondDriverID){ poles in
                                if let poles = poles {
                                    secondDriverPoles = String(poles)
                                }
                                else{
                                    print("Driver not found")
                                }
                            }
                        }
                        else{
                            secondDriverPoles = "No pole data from before 2003"
                        }
                        
                        if secondDriverWins != ttlRacesTwo || count > 4{
                            timer.invalidate()
                        }
                        else{
                            count += 1
                        }
                    }
                    
                }
                
            }
            
            
            VStack(){ //eventually make this a button that takes to a navigation so this looks better...maybe...low priority
                if firstDriverWins != -1 && secondDriverWins != -1 && firstDriverPoles != "" && secondDriverPoles != "" && firstDriverPos != -1 && secondDriverPos != -1 && firstDriverPts != -1 && secondDriverPts != -1{
                    let firstScore: Int = calcScore(wins: firstDriverWins, poles: firstDriverPoles, races: ttlRacesOne, pos: firstDriverPos, pts: firstDriverPts)
                    
                    let secondScore: Int = calcScore(wins: secondDriverWins, poles: secondDriverPoles, races: ttlRacesTwo, pos: secondDriverPos, pts: secondDriverPts)
                    
                    ViewThatFits{
                        Text("\(firstYear) \(firstName) V.S. \(secondYear) \(secondName)")
                            .font(.subheadline)
                            .lineLimit(1)
                            .padding()
                    }
                    HStack{
                        Spacer()
                        if firstDriverWins > secondDriverWins{
                            Text("Wins: \(firstDriverWins)")
                                .foregroundColor(.green)
                            Spacer()
                            Text("Wins: \(secondDriverWins)")
                                .foregroundColor(.red)
                        }
                        else if secondScore > firstScore{
                            Text("Wins: \(firstDriverWins)")
                                .foregroundColor(.red)
                            Spacer()
                            Text("Wins: \(secondDriverWins)")
                                .foregroundColor(.green)
                        }
                        else{
                            Text("Wins: \(firstDriverWins)")
                                .foregroundColor(.yellow)
                            Spacer()
                            Text("Wins: \(secondDriverWins)")
                                .foregroundColor(.yellow)
                        }
                        Spacer()
                    }
                    Spacer()
                    HStack{
                        Spacer()
                        if firstDriverPts > secondDriverPts{
                            Text("Points: \(String(format: "%g",firstDriverPts))")
                                .foregroundColor(.green)
                            Spacer()
                            Text("Points: \(String(format: "%g",secondDriverPts))")
                                .foregroundColor(.red)
                        }
                        else if secondDriverPts > firstDriverPts{
                            Text("Points: \(String(format: "%g",firstDriverPts))")
                                .foregroundColor(.red)
                            Spacer()
                            Text("Points: \(String(format: "%g",secondDriverPts))")
                                .foregroundColor(.green)
                        }
                        else{
                            Text("Points: \(String(format: "%g",firstDriverPts))")
                                .foregroundColor(.yellow)
                            Spacer()
                            Text("Points: \(String(format: "%g",secondDriverPts))")
                                .foregroundColor(.yellow)
                        }
                        Spacer()
                    }
                    Spacer()
                    HStack{
                        Spacer()
                        if firstDriverPos < secondDriverPos{
                            Text("Drivers Standings: \(firstDriverPos)")
                                .foregroundColor(.green)
                            Spacer()
                            Text("Drivers Standings: \(secondDriverPos)")
                                .foregroundColor(.red)
                        }
                        else if secondDriverPos < firstDriverPos{
                            Text("Drivers Standings: \(firstDriverPos)")
                                .foregroundColor(.red)
                            Spacer()
                            Text("Drivers Standings: \(secondDriverPos)")
                                .foregroundColor(.green)
                        }
                        else{
                            Text("Drivers Standings: \(firstDriverPos)")
                                .foregroundColor(.yellow)
                            Spacer()
                            Text("Drivers Standings: \(secondDriverPos)")
                                .foregroundColor(.yellow)
                        }
                        Spacer()
                    }
                    Spacer()
                    HStack{
                        Spacer()
                        if firstDriverPoles == "No pole data from before 2003" || secondDriverPoles == "No pole data from before 2003"{
                            Text("Pole Positions: \(firstDriverPoles)")
                            Spacer()
                            Text("Pole Positions: \(secondDriverPoles)")
                            
                        }
                        else if Int(firstDriverPoles) ?? 0 > Int(secondDriverPoles) ?? 0{
                            Text("Pole Positions: \(firstDriverPoles)")
                                .foregroundColor(.green)
                            Spacer()
                            Text("Pole Positions: \(secondDriverPoles)")
                                .foregroundColor(.red)
                        }
                        else if Int(firstDriverPoles) ?? 0 < Int(secondDriverPoles) ?? 0{
                            Text("Pole Positions: \(firstDriverPoles)")
                                .foregroundColor(.red)
                            Spacer()
                            Text("Pole Positions: \(secondDriverPoles)")
                                .foregroundColor(.green)
                        }
                        else{
                            Text("Pole Positions: \(firstDriverPoles)")
                                .foregroundColor(.yellow)
                            Spacer()
                            Text("Pole Positions: \(secondDriverPoles)")
                                .foregroundColor(.yellow)
                        }
                        
                        Spacer()
                    }
                    Spacer()
                    HStack{
                        Spacer()
                        if firstScore > secondScore{
                            Text("ForumlaStats Score: \(firstScore)")
                                .foregroundColor(.green)
                            Spacer()
                            Text("FormulaStats Score: \(secondScore)")
                                .foregroundColor(.red)
                        }
                        else if secondScore > firstScore{
                            Text("ForumlaStats Score: \(firstScore)")
                                .foregroundColor(.red)
                            Spacer()
                            Text("FormulaStats Score: \(secondScore)")
                                .foregroundColor(.green)
                        }
                        else{
                            Text("ForumlaStats Score: \(firstScore)")
                                .foregroundColor(.yellow)
                            Spacer()
                            Text("FormulaStats Score: \(secondScore)")
                                .foregroundColor(.yellow)
                        }
                        Spacer()
                    }
                    Spacer()
                }
                else{
                    Text("Waiting for data...")
                        .font(.headline)
                }
            }
            Spacer()
            HStack{
                Spacer()
                Button("Reset"){
                    firstName = ""
                    secondName = ""
                    firstYear = ""
                    secondYear = ""
                    firstDriverID = ""
                    secondDriverID = ""
                    firstDriverPos = -1
                    secondDriverPos = -1
                    firstDriverPoles = ""
                    secondDriverPoles = ""
                    firstDriverWins = -1
                    secondDriverWins = -1
                    ttlRacesOne = -1
                    ttlRacesTwo = -1
                    firstDriverList = []
                    secondDriverList = []
                }
                Spacer()
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
