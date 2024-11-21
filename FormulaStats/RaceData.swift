import Foundation
//
//  RaceData.swift
//  FormulaStats
//
//  Created by Jacob Seiberg on 10/22/24.
//



struct DriverWins: Decodable { //struct to hold wins
    let MRData: MRData
}

struct MRData: Decodable { //struct to hold json data from API
    let total: String
}

func getDriverWins(season: String, driverId: String, completion: @escaping (Int?) -> Void) {
    //define the url string with given parameters
    let urlString = "https://ergast.com/api/f1/\(season)/drivers/\(driverId)/results/1.json"
    guard let url = URL(string: urlString) else { //create url object
        completion(nil)
        return
    }

    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else { //confirm data pulled correctly
            completion(nil)
            return
        }

        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(DriverWins.self, from: data)
            if let totalWins = Int(result.MRData.total) {
                completion(totalWins)
            } else {
                completion(nil)
            }
        } catch {
            completion(nil)
        }
    }
    task.resume()
}

    

