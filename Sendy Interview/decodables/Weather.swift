//
//  Weather.swift
//  Sendy Interview
//
//  Created by Boaz James on 14/11/2020.
//  Copyright © 2020 Boaz James. All rights reserved.
//

import Foundation

struct Weather: Decodable {
    var main: String
    var icon: String
    var description: String
}
