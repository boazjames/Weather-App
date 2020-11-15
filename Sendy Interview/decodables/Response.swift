//
//  Response.swift
//  Sendy Interview
//
//  Created by Boaz James on 14/11/2020.
//  Copyright © 2020 Boaz James. All rights reserved.
//

import Foundation

struct Response: Decodable {
    var cod: String
    var message: Int
    var list: [WeatherItem]
}
