//
//  Data.swift
//  Alculate
//
//  Created by Max Sergent on 9/26/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import UIKit
import CoreData

struct Data {
    // IDs that match CoreData entity that are used throughout app
    static var masterListID = "Alcohol"
    static var beerListID = "BeerList"
    static var liquorListID = "LiquorList"
    static var wineListID = "WineList"
    // each list represents a column on main page
    static var beerList: [(name: String, abv: String, size: String, price: String)] = []
    static var liquorList: [(name: String, abv: String, size: String, price: String)] = []
    static var wineList: [(name: String, abv: String, size: String, price: String)] = []
    // set headers to empty to iterate over letters and append into
    static var headers: [String] = []
    // matrix is dictionary of header letters and drinks that start with that letter
    static var matrix = [String: [String]]()
//    static var alcoholData = ["type": String(), "name": String(), "abv": String()] {
    static var masterList = [String: (type: String, abv: String)]() {
        didSet {
            // get all alcohol names out of alcohol data
            let alcoholNames = masterList.keys
            // go through every alcohol in list of alcohol names if it isnt empty
            if !alcoholNames.isEmpty {
                for alcohol in alcoholNames {
                    let firstLetterLastName = String(alcohol.prefix(1))
                    // if first letter does not exist in headers, add it
                    if !headers.contains(firstLetterLastName) {
                        headers.append(firstLetterLastName)
                    }
                }
                // sort headers
                headers = headers.sorted()
                // set keys of matrix dictionary to first letters of alcohol names that exist
                for header in headers {
                    matrix[header] = []
                }
                // add each alcohol name to first letter list in matrix
                for alcohol in alcoholNames {
                    let firstLetterLastName = String(alcohol.prefix(1))
                    matrix[firstLetterLastName]!.append(alcohol)
                }
                // sort each letter list in matrix alphabetically
                for header in Array(matrix.keys) {
                    matrix[header] = matrix[header]!.sorted()
                }
            }
        }
    }
    
//    func updateCoreData(for attribute: String, from entity: String, oldValue: String, newValue: String) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
//        //fetchRequest.predicate = NSPredicate(format: "userID = %@ AND name = %&", argumentArray: value)
//        //fetchRequest.predicate = NSPredicate(format: "userID == %@", oldValue)
//        fetchRequest.predicate = NSPredicate(format: "%K BEGINSWITH[cd] %@", attribute, oldValue)
//        do {
//            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
//            if results?.count != 0 { // Atleast one was returned
//                // In my case, I only updated the first item in results
//                //print("results: \(results![0])")
//                results![0].setValue(newValue, forKey: attribute)
//            }
//        }
//        catch {print("Fetch Failed: \(error)")}
//        do {
//            try managedContext.save()
//        }
//        catch {print("Saving Core Data Failed: \(error)")}
//    }
            
    static func loadList(for entity: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        if entity == "Alcohol" {
            let objects = try! managedContext.fetch(fetch) as! [Alcohol]
            for obj in objects {
                Data.masterList[obj.name!] = (type: obj.type!, abv: obj.abv!)
            }
        }
        else {
            if entity == Data.beerListID {
                Data.beerList = []
                let objects = try! managedContext.fetch(fetch) as! [BeerList]
                for obj in objects {
                    Data.beerList.append((name: obj.name!, abv: obj.abv!, size: obj.size!, price: obj.price!))
                }
                Data.beerList = Data.beerList.sorted { (drink1, drink2) -> Bool in
                    let calc1 = ((Double(drink1.abv)!*Double(drink1.size)!)/0.6)
                    let calc2 = ((Double(drink2.abv)!*Double(drink2.size)!)/0.6)
                    return Double(drink1.price)!/calc1 < Double(drink2.price)!/calc2
                }
            }
            else if entity == Data.liquorListID {
                Data.liquorList = []
                let objects = try! managedContext.fetch(fetch) as! [LiquorList]
                for obj in objects {
                    Data.liquorList.append((name: obj.name!, abv: obj.abv!, size: obj.size!, price: obj.price!))
                }
                Data.liquorList = Data.liquorList.sorted { (drink1, drink2) -> Bool in
                    let calc1 = ((Double(drink1.abv)!*Double(drink1.size)!)/0.6)
                    let calc2 = ((Double(drink2.abv)!*Double(drink2.size)!)/0.6)
                    return Double(drink1.price)!/calc1 < Double(drink2.price)!/calc2
                }
            }
            else if entity == Data.wineListID {
                Data.wineList = []
                let objects = try! managedContext.fetch(fetch) as! [WineList]
                for obj in objects {
                    Data.wineList.append((name: obj.name!, abv: obj.abv!, size: obj.size!, price: obj.price!))
                }
                Data.wineList = Data.wineList.sorted { (drink1, drink2) -> Bool in
                    let calc1 = ((Double(drink1.abv)!*Double(drink1.size)!)/0.6)
                    let calc2 = ((Double(drink2.abv)!*Double(drink2.size)!)/0.6)
                    return Double(drink1.price)!/calc1 < Double(drink2.price)!/calc2
                }
            }
        }
    }
    
    static func saveToMaster(ofType type: String, named name: String, withABVof abv: String) {
        // if name exists, this will overwrite that name
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Alcohol", in: managedContext)!
        let alcohol = NSManagedObject(entity: entity, insertInto: managedContext)
        alcohol.setValue(name, forKeyPath: "name")
        alcohol.setValue(type, forKeyPath: "type")
        alcohol.setValue(abv, forKeyPath: "abv")
        do {
            try managedContext.save()
            Data.loadList(for: "Alcohol")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    static func saveToList(_ list: String, wName name: String, wABV abv: String, wSize size: String, wPrice price: String) {
        // if name exists, this will overwrite that name
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        var entity: NSEntityDescription!
        entity = NSEntityDescription.entity(forEntityName: list, in: managedContext)!
        let listToUpdate = NSManagedObject(entity: entity, insertInto: managedContext)
        listToUpdate.setValue(name, forKeyPath: "name")
        listToUpdate.setValue(abv, forKeyPath: "abv")
        listToUpdate.setValue(size, forKeyPath: "size")
        listToUpdate.setValue(price, forKeyPath: "price")
        do {
            try managedContext.save()
            loadList(for: list)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    static func deleteMaster(wName name: String, wABV abv: String, wType type: String) {
        // if name exists, this will overwrite that name
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Alcohol")
        let p1 = NSPredicate(format: "%K == %@", "name", name)
        let p2 = NSPredicate(format: "%K == %@", "abv", abv)
        let p3 = NSPredicate(format: "%K == %@", "type", type)
        deleteFetch.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p1, p2, p3])
        deleteFetch.fetchLimit = 1
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    static func deleteFromList(_ list: String, wName name: String, wABV abv: String, wSize size: String, wPrice price: String) {
        // if name exists, this will overwrite that name
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: list)
        let p1 = NSPredicate(format: "%K == %@", "name", name)
        let p2 = NSPredicate(format: "%K == %@", "abv", abv)
        let p3 = NSPredicate(format: "%K == %@", "size", size)
        let p4 = NSPredicate(format: "%K == %@", "price", price)
        deleteFetch.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p1, p2, p3, p4])
        deleteFetch.fetchLimit = 1
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
            loadList(for: list)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    static func deleteCoreDataFor(entity: String) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
        } catch {
            print ("There was an error")
        }
    }
}
