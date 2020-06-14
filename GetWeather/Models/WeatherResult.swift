//
//  WeatherResult.swift
//  GetWeather
//
//  Created by Anuranjan Bose on 14/06/20.
//  Copyright © 2020 Anuranjan Bose. All rights reserved.
//

import Foundation

struct WeatherResult: Decodable {

    let weather: Weather
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case weather = "main"
        case name
    }
}

struct Weather: Decodable {
    
    let temperature: Double
    let humidity: Double
    
    private enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case humidity = "humidity"
    }
}
