//
//  ContentView.swift
//  FormulaStats
//
//  Created by Jacob Seiberg on 10/22/24.
//

import SwiftUI

struct ContentView: View {
    var body : some View {
        NavigationStack() {
            VStack{
                Text("Welcome to FormulaStats!")
                    .font(.title)
                    .bold()
                    .padding()
                NavigationLink(destination: CompareScreen()) {
                    Text("Compare Drivers")
                        .font(.title)
                }
                .padding()
                Text("Or")
                    .padding()
                NavigationLink(destination: GameScreen()){
                    Text("Play the FormulaStats Game")
                        .font(.title)
                }
                
            }
        }
    }
    
}

struct CompareScreen: View {
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
    
    @State private var isLoading: Bool = false
    @State private var showingResults: Bool = false
      
    var body: some View {
        VStack(spacing: 20) {
            if !showingResults {
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
                            Task {
                                firstDriverList = await getDriversListAsync(season: firstYear) ?? []
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
                            Task {
                                secondDriverList = await getDriversListAsync(season: secondYear) ?? []
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
                        Task {
                            await fetchAllDriverData()
                            showingResults = true
                        }
                    }
                    .disabled(isLoading)
                }
                
                Spacer()
            } else {
                if isLoading {
                    Spacer()
                    ProgressView("Loading data...")
                        .padding()
                    Spacer()
                } else if firstDriverWins != -1 && secondDriverWins != -1 && firstDriverPoles != "" && secondDriverPoles != "" && firstDriverPos != -1 && secondDriverPos != -1 && firstDriverPts != -1 && secondDriverPts != -1{
                    let firstScore: Int = calcScore(wins: firstDriverWins, poles: firstDriverPoles, races: ttlRacesOne, pos: firstDriverPos, pts: firstDriverPts)
                    let secondScore: Int = calcScore(wins: secondDriverWins, poles: secondDriverPoles, races: ttlRacesTwo, pos: secondDriverPos, pts: secondDriverPts)
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            // Header
                            Text("Season Comparison")
                                .font(.title2)
                                .bold()
                                .padding(.top)
                            
                            // Driver Names and Years
                            HStack(spacing: 20) {
                                VStack {
                                    Text(firstName)
                                        .font(.headline)
                                        .multilineTextAlignment(.center)
                                    Text(firstYear)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity)
                                
                                Text("VS")
                                    .font(.title3)
                                    .foregroundColor(.secondary)
                                
                                VStack {
                                    Text(secondName)
                                        .font(.headline)
                                        .multilineTextAlignment(.center)
                                    Text(secondYear)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            
                            // Statistics Grid
                            VStack(spacing: 12) {
                                StatRow(
                                    label: "Wins",
                                    firstValue: "\(firstDriverWins)",
                                    secondValue: "\(secondDriverWins)",
                                    firstWins: firstDriverWins > secondDriverWins,
                                    secondWins: secondDriverWins > firstDriverWins
                                )
                                
                                StatRow(
                                    label: "Points",
                                    firstValue: String(format: "%g", firstDriverPts),
                                    secondValue: String(format: "%g", secondDriverPts),
                                    firstWins: firstDriverPts > secondDriverPts,
                                    secondWins: secondDriverPts > firstDriverPts
                                )
                                
                                StatRow(
                                    label: "Championship Position",
                                    firstValue: "\(firstDriverPos)",
                                    secondValue: "\(secondDriverPos)",
                                    firstWins: firstDriverPos < secondDriverPos,
                                    secondWins: secondDriverPos < firstDriverPos
                                )
                                
                                if firstDriverPoles == "No pole data from before 2003" || secondDriverPoles == "No pole data from before 2003" {
                                    StatRow(
                                        label: "Pole Positions",
                                        firstValue: firstDriverPoles,
                                        secondValue: secondDriverPoles,
                                        firstWins: false,
                                        secondWins: false,
                                        showColors: false
                                    )
                                } else {
                                    StatRow(
                                        label: "Pole Positions",
                                        firstValue: firstDriverPoles,
                                        secondValue: secondDriverPoles,
                                        firstWins: (Int(firstDriverPoles) ?? 0) > (Int(secondDriverPoles) ?? 0),
                                        secondWins: (Int(secondDriverPoles) ?? 0) > (Int(firstDriverPoles) ?? 0)
                                    )
                                }
                                
                                StatRow(
                                    label: "FormulaStats Score",
                                    firstValue: "\(firstScore)",
                                    secondValue: "\(secondScore)",
                                    firstWins: firstScore > secondScore,
                                    secondWins: secondScore > firstScore
                                )
                            }
                            .padding(.horizontal)
                            
                            // Reset Button
                            Button(action: {
                                showingResults = false
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
                                firstDriverPts = -1
                                secondDriverPts = -1
                                ttlRacesOne = 0
                                ttlRacesTwo = 0
                                firstDriverList = []
                                secondDriverList = []
                            }) {
                                Text("New Comparison")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(12)
                            }
                            .padding(.horizontal)
                            .padding(.bottom)
                        }
                    }
                }
            }
        }
        .padding()
    }
    
    // New async function to fetch all driver data sequentially
    func fetchAllDriverData() async {
        isLoading = true
        
        // Reset all data
        firstDriverWins = -1
        secondDriverWins = -1
        firstDriverPts = -1
        secondDriverPts = -1
        firstDriverPos = -1
        secondDriverPos = -1
        firstDriverPoles = ""
        secondDriverPoles = ""
        
        let driverOneF = splitName(firstName).0
        let driverOneL = splitName(firstName).1
        let driverTwoF = splitName(secondName).0
        let driverTwoL = splitName(secondName).1
        
        print("Fetching data for \(firstName) and \(secondName)")
        
        // Fetch driver IDs
        async let id1 = getDriverIdAsync(season: firstYear, givenName: driverOneF, familyName: driverOneL)
        async let id2 = getDriverIdAsync(season: secondYear, givenName: driverTwoF, familyName: driverTwoL)
        
        guard let driverId1 = await id1, let driverId2 = await id2 else {
            print("Failed to fetch driver IDs")
            isLoading = false
            return
        }
        
        firstDriverID = driverId1
        secondDriverID = driverId2
        print("Got driver IDs: \(driverId1), \(driverId2)")
        
        // Fetch all data in parallel using async let
        async let races1 = getRacesInSeasonAsync(season: firstYear, driverId: driverId1)
        async let races2 = getRacesInSeasonAsync(season: secondYear, driverId: driverId2)
        async let wins1 = getDriverWinsAsync(season: firstYear, driverId: driverId1)
        async let wins2 = getDriverWinsAsync(season: secondYear, driverId: driverId2)
        async let pts1 = getPointsInSeasonAsync(season: firstYear, driverID: driverId1)
        async let pts2 = getPointsInSeasonAsync(season: secondYear, driverID: driverId2)
        async let pos1 = getFinalPositionInSeasonAsync(season: firstYear, driverID: driverId1)
        async let pos2 = getFinalPositionInSeasonAsync(season: secondYear, driverID: driverId2)
        
        // Wait for all to complete
        ttlRacesOne = await races1 ?? 0
        ttlRacesTwo = await races2 ?? 0
        firstDriverWins = await wins1 ?? 0
        secondDriverWins = await wins2 ?? 0
        firstDriverPts = await pts1 ?? 0
        secondDriverPts = await pts2 ?? 0
        firstDriverPos = await pos1 ?? 0
        secondDriverPos = await pos2 ?? 0
        
        print("Fetched basic data - First: wins=\(firstDriverWins), pts=\(firstDriverPts), pos=\(firstDriverPos)")
        print("Fetched basic data - Second: wins=\(secondDriverWins), pts=\(secondDriverPts), pos=\(secondDriverPos)")
        
        // Handle poles separately due to year check
        let intFirstYear = Int(firstYear) ?? 0
        let intSecondYear = Int(secondYear) ?? 0
        
        if intFirstYear >= 2003 {
            if let poles = await getDriverPolesAsync(season: firstYear, driverId: driverId1) {
                firstDriverPoles = String(poles)
            } else {
                firstDriverPoles = "0"
            }
        } else {
            firstDriverPoles = "No pole data from before 2003"
        }
        
        if intSecondYear >= 2003 {
            if let poles = await getDriverPolesAsync(season: secondYear, driverId: driverId2) {
                secondDriverPoles = String(poles)
            } else {
                secondDriverPoles = "0"
            }
        } else {
            secondDriverPoles = "No pole data from before 2003"
        }
        
        print("All data fetched! First poles: \(firstDriverPoles), Second poles: \(secondDriverPoles)")
        isLoading = false
    }
}

// MARK: - Async wrapper functions
// These convert the callback-based functions to async/await

func getDriversListAsync(season: String) async -> [String]? {
    await withCheckedContinuation { continuation in
        getDriversList(season: season) { drivers in
            continuation.resume(returning: drivers)
        }
    }
}

func getDriverIdAsync(season: String, givenName: String, familyName: String) async -> String? {
    await withCheckedContinuation { continuation in
        getDriverId(season: season, givenName: givenName, familyName: familyName) { driverId in
            continuation.resume(returning: driverId)
        }
    }
}

func getDriverWinsAsync(season: String, driverId: String) async -> Int? {
    await withCheckedContinuation { continuation in
        getDriverWins(season: season, driverId: driverId) { wins in
            continuation.resume(returning: wins)
        }
    }
}

func getRacesInSeasonAsync(season: String, driverId: String) async -> Int? {
    await withCheckedContinuation { continuation in
        getRacesInSeason(season: season, driverId: driverId) { races in
            continuation.resume(returning: races)
        }
    }
}

func getPointsInSeasonAsync(season: String, driverID: String) async -> Float? {
    await withCheckedContinuation { continuation in
        getPointsInSeason(season: season, driverID: driverID) { points in
            continuation.resume(returning: points)
        }
    }
}

func getFinalPositionInSeasonAsync(season: String, driverID: String) async -> Int? {
    await withCheckedContinuation { continuation in
        getFinalPositionInSeason(season: season, driverID: driverID) { position in
            continuation.resume(returning: position)
        }
    }
}

func getDriverPolesAsync(season: String, driverId: String) async -> Int? {
    await withCheckedContinuation { continuation in
        getDriverPoles(season: season, driverId: driverId) { poles in
            continuation.resume(returning: poles)
        }
    }
}

// MARK: - GameScreen
struct GameScreen: View{
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
    
    var body: some View{
        VStack{
            Button("Generate Two Drivers"){
                let yearOne = Int.random(in: 2003...2023)
                let yearTwo = Int.random(in: 2003...2023)
                firstYear = String(yearOne)
                secondYear = String(yearTwo)
                
                getDriversList(season: firstYear) { drivers in
                    if let drivers = drivers {
                        firstDriverList = drivers
                    } else {
                        print("Failed to fetch drivers")
                    }
                }
                
                getDriversList(season: secondYear) { drivers in
                    if let drivers = drivers {
                        secondDriverList = drivers
                    } else {
                        print("Failed to fetch drivers")
                    }
                }
                
                firstName = firstDriverList.randomElement() ?? ""
                secondName = secondDriverList.randomElement() ?? ""
                if firstName != "" && secondName != "" {
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
            .font(.title)
            Spacer()
            if firstDriverWins == -1 || secondDriverWins == -1{
                Text("Waiting for data...")
            }
            else{
                //add a way to go 1 by 1 down the list of stats and
                //have user guess higher or lower for each one
            }
            Spacer()
        }
    }
}

// MARK: - ContentView Previews
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: - StatRow Component
struct StatRow: View {
    let label: String
    let firstValue: String
    let secondValue: String
    let firstWins: Bool
    let secondWins: Bool
    var showColors: Bool = true
    
    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
            
            HStack(spacing: 12) {
                // First driver column
                Text(firstValue)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(showColors ? (firstWins ? .green : (secondWins ? .red : .orange)) : .primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemGray6))
                    )
                
                // VS divider
                Text("vs")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(width: 30)
                
                // Second driver column
                Text(secondValue)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(showColors ? (secondWins ? .green : (firstWins ? .red : .orange)) : .primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemGray6))
                    )
            }
        }
        .padding(.vertical, 4)
    }
}
