//
//  TodayWeatherResponse.swift
//  Sendy Interview
//
//  Created by Boaz James on 15/11/2020.
//  Copyright © 2020 Boaz James. All rights reserved.
//

import Foundation

struct TodayWeatherResponse: Decodable {
    var main: MainWeather
    var weather: [Weather]
    var wind: Wind
}
