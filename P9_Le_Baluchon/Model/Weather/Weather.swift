//
//  Weather.swift
//  P9_Le_Baluchon
//
//  Created by arnaud kiefer on 16/06/2021.
//

import Foundation

struct AllWeather: Codable {
    let weather: [Weather]
    let main: Main
    let dt: Int
    let name: String
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description, main, icon: String
    let id: Int
}
