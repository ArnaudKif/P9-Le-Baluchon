//
//  Conversion.swift
//  P9_Le_Baluchon
//
//  Created by arnaud kiefer on 21/06/2021.
//

import Foundation

struct CurrencyRate: Codable {
    let success: Bool
    let timestamp: Int
    let base: String
    let date: String
    let rates : Rates
}

struct Rates: Codable {
    let USD: Double
    let AUD: Double
    let CAD: Double
    let CHF: Double
    let CNY: Double
    let GBP: Double
    let JPY: Double
}

let rateChoice = ["$ US",
                  "$ AUS",
                  "$ CA",
                  "F CH",
                  "¥ CN",
                  "£ GB",
                  "¥ JP"
                 ]
