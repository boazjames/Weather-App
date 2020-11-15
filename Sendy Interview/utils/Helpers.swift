//
//  Helpers.swift
//  Sendy Interview
//
//  Created by Boaz James on 13/11/2020.
//  Copyright © 2020 Boaz James. All rights reserved.
//

import Foundation
import CoreData
import UIKit

func clearLocationDb() {
    guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
            return
    }
    
    let managedContext =
        appDelegate.databaseContext
    
    let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "Location")
    
    do {
        let locations = try managedContext.fetch(fetchRequest)
        locations.forEach { (item) in
            managedContext.delete(item)
        }
        try managedContext.save()
    } catch _ {}
}

func saveAddress(address: String, lat: Double, lng: Double) -> Bool {
    guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
            return false
    }
    
    let managedContext = appDelegate.databaseContext
    
    let entity = NSEntityDescription.entity(forEntityName: "Location", in: managedContext)!
    
    let location = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
    
    location.setValue(address, forKeyPath: "address")
    location.setValue(lat, forKeyPath: "lat")
    location.setValue(lng, forKeyPath: "lng")
    
    do {
        try managedContext.save()
        return true
    } catch _ {
        return false
    }
}

func createLocationEntity(location address: String, lat: Double, lng: Double) -> NSManagedObject? {
    guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
            return nil
    }
    
    let managedContext = appDelegate.databaseContext
    
    let entity = NSEntityDescription.entity(forEntityName: "Location", in: managedContext)!
    
    let location = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
    
    location.setValue(address, forKeyPath: "address")
    location.setValue(lat, forKeyPath: "lat")
    location.setValue(lng, forKeyPath: "lng")
    return location
}
