//
//  DriverList.swift
//  FormulaStats
//
//  Created by Jacob Seiberg on 11/20/24.
//

import Foundation

struct DriverList: Decodable {
    let MRData: MRDataTable
}

struct MRDataTable: Decodable {
    let DriverTable: DriverTable
}

struct DriverTable: Decodable {
    let Drivers: [Driver]
}

struct Driver: Decodable {
    let driverId: String
    let givenName: String
    let familyName: String
}

struct ErgastResponse: Decodable {
    let MRData: MRData
}

func getDriversList(season: String, completion: @escaping ([String]?) -> Void) {
    let urlString = "https://api.jolpi.ca/ergast/f1/\(season)/drivers.json"
    guard let url = URL(string: urlString) else {
        completion(nil)
        return
    }

    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
            completion(nil)
            return
        }

        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(DriverList.self, from: data)
            let driverNames = result.MRData.DriverTable.Drivers.map { "\($0.givenName) \($0.familyName)" }
            completion(driverNames)
        } catch {
            completion(nil)
        }
    }
    task.resume()
}

func getDriverId(season: String, givenName: String, familyName: String, completion: @escaping (String?) -> Void) {
    let urlString = "https://api.jolpi.ca/ergast/f1/\(season)/drivers.json"
    guard let url = URL(string: urlString) else {
        completion(nil)
        return
    }

    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
            completion(nil)
            return
        }

        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(DriverList.self, from: data)
            if let driver = result.MRData.DriverTable.Drivers.first(where: { $0.givenName.lowercased() == givenName.lowercased() && $0.familyName.lowercased() == familyName.lowercased() }) {
                completion(driver.driverId)
            } else {
                completion(nil)
            }
        } catch {
            completion(nil)
        }
    }
    task.resume()
}


