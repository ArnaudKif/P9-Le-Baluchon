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


func convertDate(unix:Int) -> String {
    let ns_date = NSDate(timeIntervalSince1970: TimeInterval(unix))
    let date:Date = ns_date as Date
    
    let date_formatter: DateFormatter = DateFormatter()
    date_formatter.dateFormat = "dd MM YYYY à HH:mm"
    let date_string = date_formatter.string(from: date)
    return date_string
} // end of convertDate

