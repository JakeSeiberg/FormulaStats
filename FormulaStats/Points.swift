import Foundation

//created a new file for points because the amount of structs required was extremely messy in RaceData
struct DriverStandingsResponse: Decodable {
    let MRData: PointsMRData
}

struct PointsMRData: Decodable {
    let StandingsTable: StandingsTable
}

struct StandingsTable: Decodable {
    let StandingsLists: [StandingsList]
}

struct StandingsList: Decodable {
    let DriverStandings: [DriverStanding]
}

struct DriverStanding: Decodable {
    let points: String
    let position: String
}

func getPointsInSeason(season: String, driverID: String, completion: @escaping (Float?) -> Void) {
    let urlString = "https://ergast.com/api/f1/\(season)/drivers/\(driverID)/driverStandings.json"
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
            let standingsResponse = try JSONDecoder().decode(DriverStandingsResponse.self, from: data)
            //extremely long path through the JSON to find total points
            if let pointsString = standingsResponse.MRData.StandingsTable.StandingsLists.first?.DriverStandings.first?.points,
               let points = Float(pointsString){
                completion(points)
            }
            else{
                completion(nil)
            }
        }
        catch{
            completion(nil)
        }
    }

    task.resume()
}

//havent tested this yet...might work
func getFinalPositionInSeason(season: String, driverID: String, completion: @escaping (Int?) -> Void) {
    let urlString = "https://ergast.com/api/f1/\(season)/drivers/\(driverID)/driverStandings.json"
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
            let standingsResponse = try JSONDecoder().decode(DriverStandingsResponse.self, from: data)
            if let positionString = standingsResponse.MRData.StandingsTable.StandingsLists.first?.DriverStandings.first?.position,
               let position = Int(positionString){
                completion(position)
            }
            else{
                completion(nil)
            }
        }
        catch{
            completion(nil)
        }
    }
    
    task.resume()
}
