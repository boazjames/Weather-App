//
//  MainWeather.swift
//  Sendy Interview
//
//  Created by Boaz James on 14/11/2020.
//  Copyright © 2020 Boaz James. All rights reserved.
//

import Foundation

struct MainWeather: Decodable {
    var temp: Float
    var humidity: Float
    var feels_like: Float
}
