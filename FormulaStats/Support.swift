//
//  Support.swift
//  FormulaStats
//
//  Created by Jacob Seiberg on 11/21/24.
//


func splitName(_ name: String) -> (String, String) {
    let split = name.split(separator: " ")
    return (String(split.first!), split.dropFirst().joined(separator: " "))
}

func calcScore(wins: Int, poles: String, races: Int, pos: Int, pts: Float) -> Int {
    // Prevent division by zero
    guard races > 0 else {
        print("Warning: races is 0, returning 0 score")
        return 0
    }
    
    let poleInt = Int(poles) ?? 0
    let winScore = wins * 32
    let poleScore = poleInt * 16
    let ptsScore = Int(pts) * 2
    let posScore = abs(pos-30) * 2
    let subScore = winScore + poleScore + ptsScore + posScore
    
    return subScore / races
}
