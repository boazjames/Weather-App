//
//  Configuration.swift
//  Sendy Interview
//
//  Created by Boaz James on 14/11/2020.
//  Copyright © 2020 Boaz James. All rights reserved.
//

import Foundation

let unitsKey = "units"

class Configuration {

    static func value<T>(defaultValue: T, forKey key: String) -> T{

        let preferences = UserDefaults.standard
        return preferences.object(forKey: key) == nil ? defaultValue : preferences.object(forKey: key) as! T
    }

    static func value(value: Any, forKey key: String){

        UserDefaults.standard.set(value, forKey: key)
    }

}

extension Configuration {
    static func setUnits(_ val: String) {
        value(value: val, forKey: unitsKey)
    }
    
    static func getUnits() -> String {
        return value(defaultValue: UNIT_STANDARD, forKey: unitsKey)
    }
}
