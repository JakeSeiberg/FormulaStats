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
    
    @State private var firstDriverID: String = ""
    @State private var secondDriverID: String = ""
    
    @State private var firstDriverWins: Int = -1
    @State private var secondDriverWins: Int = -1
    
    @State private var firstDriverPts: Float = -1
    @State private var secondDriverPts: Float = -1
    
    @State private var firstDriverPos : Int = -1
    @State private var secondDriverPos : Int = -1
    
    @State private var firstDriverPoles: String = ""
    @State private var secondDriverPoles: String = ""
    
    @State private var isLoading: Bool = false
    @State private var currentStatIndex: Int = 0
    @State private var score: Int = 0
    @State private var gameOver: Bool = false
    @State private var showingAnswer: Bool = false
    @State private var lastGuessCorrect: Bool = false
    @State private var generationAttempts: Int = 0
    
    let stats = ["Wins", "Points", "Championship Position", "Pole Positions", "FormulaStats Score"]
    
    var body: some View{
        VStack(spacing: 20){
            if !isLoading && firstDriverWins == -1 {
                // Initial state - show generate button
                VStack(spacing: 20) {
                    Text("FormulaStats Game")
                        .font(.title)
                        .bold()
                    
                    Text("Guess which driver had better stats!")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Button("Generate Two Drivers"){
                        generateDrivers()
                    }
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                Spacer()
            } else if isLoading {
                Spacer()
                ProgressView("Loading drivers...")
                    .padding()
                Spacer()
            } else if gameOver {
                // Game over screen
                VStack(spacing: 20) {
                    Text("Game Over!")
                        .font(.largeTitle)
                        .bold()
                    
                    Text("Final Score: \(score)/5")
                        .font(.title)
                    
                    Text(scoreMessage())
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding()
                    
                    Button("Play Again") {
                        resetGame()
                    }
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                Spacer()
            } else {
                // Game in progress
                VStack(spacing: 20) {
                    // Score display
                    HStack {
                        Text("Score: \(score)/\(currentStatIndex)")
                            .font(.headline)
                        Spacer()
                        Text("Question \(currentStatIndex + 1)/5")
                            .font(.headline)
                    }
                    .padding(.horizontal)
                    
                    if !showingAnswer && currentStatIndex < 5 {
                        // Question screen
                        Text("Which driver had better \(stats[currentStatIndex])?")
                            .font(.title2)
                            .bold()
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Spacer()
                        
                        // Driver cards
                        HStack(spacing: 20) {
                            // First driver button
                            Button(action: {
                                checkAnswer(selectedFirst: true)
                            }) {
                                VStack(spacing: 10) {
                                    Text(firstName)
                                        .font(.title3)
                                        .bold()
                                        .multilineTextAlignment(.center)
                                    Text(firstYear)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.blue, lineWidth: 2)
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            // Second driver button
                            Button(action: {
                                checkAnswer(selectedFirst: false)
                            }) {
                                VStack(spacing: 10) {
                                    Text(secondName)
                                        .font(.title3)
                                        .bold()
                                        .multilineTextAlignment(.center)
                                    Text(secondYear)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.blue, lineWidth: 2)
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    } else {
                        // Answer reveal screen
                        VStack(spacing: 20) {
                            Text(lastGuessCorrect ? "Correct! ✓" : "Wrong ✗")
                                .font(.title)
                                .bold()
                                .foregroundColor(lastGuessCorrect ? .green : .red)
                                .padding()
                            
                            Text(stats[currentStatIndex - 1])
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            // Show actual stats
                            AnswerRevealRow(
                                firstName: firstName,
                                firstYear: firstYear,
                                firstValue: getCurrentStatValue(isFirst: true),
                                secondName: secondName,
                                secondYear: secondYear,
                                secondValue: getCurrentStatValue(isFirst: false),
                                firstBetter: isFirstBetter()
                            )
                            
                            Spacer()
                            
                            Button(currentStatIndex < 5 ? "Next Question" : "See Final Score") {
                                if currentStatIndex < 5 {
                                    showingAnswer = false
                                } else {
                                    gameOver = true
                                }
                            }
                            .font(.title2)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                    }
                }
                .padding()
            }
        }
    }
    
    func generateDrivers() {
        isLoading = true
        generationAttempts += 1
        
        // Prevent infinite loop - max 5 attempts
        if generationAttempts > 5 {
            print("Too many failed attempts, stopping")
            isLoading = false
            generationAttempts = 0
            return
        }
        
        Task {
            let yearOne = Int.random(in: 2003...2023)
            let yearTwo = Int.random(in: 2003...2023)
            firstYear = String(yearOne)
            secondYear = String(yearTwo)
            
            // Get driver lists
            guard let drivers1 = await getDriversListAsync(season: firstYear),
                  let drivers2 = await getDriversListAsync(season: secondYear),
                  !drivers1.isEmpty,
                  !drivers2.isEmpty else {
                print("Failed to fetch driver lists")
                isLoading = false
                generationAttempts = 0
                return
            }
            
            firstName = drivers1.randomElement() ?? ""
            secondName = drivers2.randomElement() ?? ""
            
            let driverOneF = splitName(firstName).0
            let driverOneL = splitName(firstName).1
            let driverTwoF = splitName(secondName).0
            let driverTwoL = splitName(secondName).1
            
            // Get driver IDs
            async let id1 = getDriverIdAsync(season: firstYear, givenName: driverOneF, familyName: driverOneL)
            async let id2 = getDriverIdAsync(season: secondYear, givenName: driverTwoF, familyName: driverTwoL)
            
            guard let driverId1 = await id1, let driverId2 = await id2 else {
                print("Failed to fetch driver IDs")
                isLoading = false
                generationAttempts = 0
                return
            }
            
            firstDriverID = driverId1
            secondDriverID = driverId2
            
            print("Fetching data for \(firstName) (\(firstYear)) vs \(secondName) (\(secondYear))")
            
            // Fetch all data in parallel
            async let races1 = getRacesInSeasonAsync(season: firstYear, driverId: driverId1)
            async let races2 = getRacesInSeasonAsync(season: secondYear, driverId: driverId2)
            async let wins1 = getDriverWinsAsync(season: firstYear, driverId: driverId1)
            async let wins2 = getDriverWinsAsync(season: secondYear, driverId: driverId2)
            async let pts1 = getPointsInSeasonAsync(season: firstYear, driverID: driverId1)
            async let pts2 = getPointsInSeasonAsync(season: secondYear, driverID: driverId2)
            async let pos1 = getFinalPositionInSeasonAsync(season: firstYear, driverID: driverId1)
            async let pos2 = getFinalPositionInSeasonAsync(season: secondYear, driverID: driverId2)
            
            let fetchedRaces1 = await races1 ?? 0
            let fetchedRaces2 = await races2 ?? 0
            firstDriverWins = await wins1 ?? 0
            secondDriverWins = await wins2 ?? 0
            firstDriverPts = await pts1 ?? 0
            secondDriverPts = await pts2 ?? 0
            firstDriverPos = await pos1 ?? 0
            secondDriverPos = await pos2 ?? 0
            
            // If races data is invalid, estimate from season year
            // Most F1 seasons have 17-23 races
            ttlRacesOne = fetchedRaces1 > 0 ? fetchedRaces1 : estimateRacesForYear(Int(firstYear) ?? 2020)
            ttlRacesTwo = fetchedRaces2 > 0 ? fetchedRaces2 : estimateRacesForYear(Int(secondYear) ?? 2020)
            
            print("Driver 1: races=\(ttlRacesOne), wins=\(firstDriverWins), pts=\(firstDriverPts), pos=\(firstDriverPos)")
            print("Driver 2: races=\(ttlRacesTwo), wins=\(secondDriverWins), pts=\(secondDriverPts), pos=\(secondDriverPos)")
            
            // Get poles
            let intFirstYear = Int(firstYear) ?? 0
            let intSecondYear = Int(secondYear) ?? 0
            
            if intFirstYear >= 2003 {
                if let poles = await getDriverPolesAsync(season: firstYear, driverId: driverId1) {
                    firstDriverPoles = String(poles)
                } else {
                    firstDriverPoles = "0"
                }
            } else {
                firstDriverPoles = "0"
            }
            
            if intSecondYear >= 2003 {
                if let poles = await getDriverPolesAsync(season: secondYear, driverId: driverId2) {
                    secondDriverPoles = String(poles)
                } else {
                    secondDriverPoles = "0"
                }
            } else {
                secondDriverPoles = "0"
            }
            
            print("Driver 1 poles: \(firstDriverPoles), Driver 2 poles: \(secondDriverPoles)")
            
            // Validate that drivers actually competed (have points or position data)
            if firstDriverPos == 0 && firstDriverPts == 0 {
                print("Warning: Driver 1 has no valid season data, regenerating...")
                generateDrivers()
                return
            }
            
            if secondDriverPos == 0 && secondDriverPts == 0 {
                print("Warning: Driver 2 has no valid season data, regenerating...")
                generateDrivers()
                return
            }
            
            // Add a small delay to ensure all state updates have propagated
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
            
            // Success! Reset attempts counter
            generationAttempts = 0
            isLoading = false
            
            print("Data loading complete and ready!")
        }
    }
    
    func checkAnswer(selectedFirst: Bool) {
        // Ensure we have valid data before checking answer
        guard ttlRacesOne > 0 && ttlRacesTwo > 0 else {
            print("Invalid race data")
            return
        }
        
        let correct = isFirstBetter() == selectedFirst
        if correct {
            score += 1
        }
        lastGuessCorrect = correct
        showingAnswer = true
        currentStatIndex += 1
    }
    
    func isFirstBetter() -> Bool {
        let statIndex = showingAnswer ? currentStatIndex - 1 : currentStatIndex
        guard statIndex >= 0 && statIndex < stats.count else { return false }
        
        let stat = stats[statIndex]
        switch stat {
        case "Wins":
            return firstDriverWins > secondDriverWins
        case "Points":
            return firstDriverPts > secondDriverPts
        case "Championship Position":
            return firstDriverPos < secondDriverPos // Lower is better
        case "Pole Positions":
            return (Int(firstDriverPoles) ?? 0) > (Int(secondDriverPoles) ?? 0)
        case "FormulaStats Score":
            let firstScore = calcScore(wins: firstDriverWins, poles: firstDriverPoles, races: ttlRacesOne, pos: firstDriverPos, pts: firstDriverPts)
            let secondScore = calcScore(wins: secondDriverWins, poles: secondDriverPoles, races: ttlRacesTwo, pos: secondDriverPos, pts: secondDriverPts)
            return firstScore > secondScore
        default:
            return false
        }
    }
    
    func getCurrentStatValue(isFirst: Bool) -> String {
        let statIndex = currentStatIndex - 1
        guard statIndex >= 0 && statIndex < stats.count else { return "N/A" }
        
        let stat = stats[statIndex]
        switch stat {
        case "Wins":
            return String(isFirst ? firstDriverWins : secondDriverWins)
        case "Points":
            return String(format: "%g", isFirst ? firstDriverPts : secondDriverPts)
        case "Championship Position":
            return String(isFirst ? firstDriverPos : secondDriverPos)
        case "Pole Positions":
            return isFirst ? firstDriverPoles : secondDriverPoles
        case "FormulaStats Score":
            if isFirst {
                return String(calcScore(wins: firstDriverWins, poles: firstDriverPoles, races: ttlRacesOne, pos: firstDriverPos, pts: firstDriverPts))
            } else {
                return String(calcScore(wins: secondDriverWins, poles: secondDriverPoles, races: ttlRacesTwo, pos: secondDriverPos, pts: secondDriverPts))
            }
        default:
            return "N/A"
        }
    }
    
    // Estimate races for a given year (since getRacesInSeason seems broken)
    func estimateRacesForYear(_ year: Int) -> Int {
        switch year {
        case 2003...2005: return 18
        case 2006...2009: return 18
        case 2010...2011: return 19
        case 2012...2015: return 19
        case 2016...2018: return 21
        case 2019: return 21
        case 2020: return 17 // COVID year
        case 2021: return 22
        case 2022...2023: return 22
        default: return 20 // Default estimate
        }
    }
    
    func scoreMessage() -> String {
        switch score {
        case 5:
            return "Perfect! You're an F1 expert! 🏆"
        case 4:
            return "Excellent! Almost perfect! 🥇"
        case 3:
            return "Good job! You know your F1! 🥈"
        case 2:
            return "Not bad! Keep practicing! 🥉"
        case 1:
            return "Better luck next time! 📚"
        default:
            return "Keep learning about F1! 🏎️"
        }
    }
    
    func resetGame() {
        firstName = ""
        secondName = ""
        firstYear = ""
        secondYear = ""
        firstDriverID = ""
        secondDriverID = ""
        firstDriverWins = -1
        secondDriverWins = -1
        firstDriverPts = -1
        secondDriverPts = -1
        firstDriverPos = -1
        secondDriverPos = -1
        firstDriverPoles = ""
        secondDriverPoles = ""
        ttlRacesOne = 0
        ttlRacesTwo = 0
        currentStatIndex = 0
        score = 0
        gameOver = false
        showingAnswer = false
        lastGuessCorrect = false
        isLoading = false
        generationAttempts = 0  // Reset attempts counter
    }
}

// MARK: - ContentView Previews
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: - AnswerRevealRow Component
struct AnswerRevealRow: View {
    let firstName: String
    let firstYear: String
    let firstValue: String
    let secondName: String
    let secondYear: String
    let secondValue: String
    let firstBetter: Bool
    
    var body: some View {
        HStack(spacing: 20) {
            DriverStatCard(
                name: firstName,
                year: firstYear,
                value: firstValue,
                isWinner: firstBetter
            )
            
            Text("vs")
                .font(.title3)
                .foregroundColor(.secondary)
            
            DriverStatCard(
                name: secondName,
                year: secondYear,
                value: secondValue,
                isWinner: !firstBetter
            )
        }
        .padding(.horizontal)
    }
}

// MARK: - DriverStatCard Component
struct DriverStatCard: View {
    let name: String
    let year: String
    let value: String
    let isWinner: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            Text(name)
                .font(.headline)
                .multilineTextAlignment(.center)
            Text(year)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.title)
                .bold()
                .foregroundColor(isWinner ? .green : .red)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(isWinner ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
        .cornerRadius(12)
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
