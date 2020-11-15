//
//  WeatherItem.swift
//  Sendy Interview
//
//  Created by Boaz James on 14/11/2020.
//  Copyright © 2020 Boaz James. All rights reserved.
//

import Foundation

struct WeatherItem: Decodable {
    var dt_txt: String
    var main: MainWeather
    var weather: [Weather]
    var wind: Wind
    var pop: Float
}
