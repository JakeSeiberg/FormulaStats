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

func getDriversList(season: String, completion: @escaping ([String]?) -> Void) {
    let urlString = "https://ergast.com/api/f1/\(season)/drivers.json"
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
