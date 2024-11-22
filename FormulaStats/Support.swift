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
