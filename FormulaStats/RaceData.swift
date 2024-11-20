import Foundation
//
//  RaceData.swift
//  FormulaStats
//
//  Created by Jacob Seiberg on 10/22/24.
//


struct TestData {
    let year: Int
}

func fetchRaceData() async throws -> Data{ //pulled from random video not sure this does anything. Didnt finish video so this is most likely a bunch of bullshit
    let url = URL(string: "http://ergast.com/api/f1/2008/5/results")!
    
    let (data,_) = try await URLSession.shared.data(from: url)
    
    return data //this is def wrong but who knows
}




//create url
/* DOES NOT WORK AT ALL YET W.I.P
func apiCall() -> any{
    let urlStr = "http://ergast.com/api/f1/2008/5/results"
    guard let url = URL(string: urlStr)else{
        print("Invalid URL")
        return
    }
    
    //create urlsession
    
    let task = URLSession.shared.dataTask(with: url){ (data, response, error) in
        //handle error
        if let error = error{
            print("Error: \(error.localizedDescription)")
            return
        }
        
        //Handle response and data
        if let data = data{
            do{
                //parse json
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print("Response JSON: \(json)")
            }
            catch{
                print("Failed to parse JSON: \(error.localizedDescription)")
            }
        }
    }
    
    task.resume()
    
    //not sure if task is the right thing to return
    //need to figure out how this actually pulls data to be returned
}
*/
