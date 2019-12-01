//
//  Data.swift
//  Alculate
//
//  Created by Max Sergent on 9/26/19.
//  Copyright © 2019 Max Sergent. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct Data {
    // IDs that match CoreData entity that are used throughout app
    static let masterListID = "Alcohol"
    static let beerListID = "BeerList"
    static let liquorListID = "LiquorList"
    static let wineListID = "WineList"
    static let IDs = [beerListID,liquorListID,wineListID]
    // each list represents a column on main page
    static var beerList: [(name: String, abv: String, size: String, price: String)] = []
    static var liquorList: [(name: String, abv: String, size: String, price: String)] = []
    static var wineList: [(name: String, abv: String, size: String, price: String)] = []
    static var lists = [beerList,liquorList,wineList]
    static var toBeDeleted: [[(name: String, abv: String, size: String, price: String)]] = [[],[],[]]
    // set headers to empty to iterate over letters and append into
    static var headers: [String] = []
    // matrix is dictionary of header letters and drinks that start with that letter
    static var matrix = [String: [String]]()
//    static var alcoholData = ["type": String(), "name": String(), "abv": String()] {
    static var isEditable = true
    static var masterList = [String: (type: String, abv: String)]() {
        didSet {
            if isEditable {
                // reset headers/matrix for when items get deleted, they are appended below, doesnt reflect delete
                headers = []
                matrix = [String: [String]]()
                // get all alcohol names out of alcohol data
                let alcoholNames = masterList.keys
                // go through every alcohol in list of alcohol names if it isnt empty
                if !alcoholNames.isEmpty {
                    for alcohol in alcoholNames {
                        let firstLetterLastName = String(alcohol.prefix(1)).capitalized
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
                        let firstLetterLastName = String(alcohol.prefix(1)).capitalized
                        matrix[firstLetterLastName]!.append(alcohol)
                    }
                    // sort each letter list in matrix alphabetically
                    for header in Array(matrix.keys) {
                        matrix[header] = matrix[header]!.sorted()
                    }
                }
            }
        }
    }
    
    static func txtFile() {
        let path = Bundle.main.path(forResource: "alcohol", ofType: "csv")
        let filemgr = FileManager.default
        if filemgr.fileExists(atPath: path!) {
            do {
                let fullText = try String(contentsOfFile: path!, encoding: .ascii)
                let readings = fullText.components(separatedBy: "\n") as [String]
                let size = readings.count
                print("- trying to pull .txt -")
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
                let managedContext = appDelegate.persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName: "Alcohol", in: managedContext)!
                for i in 1...(size-1) {
                    let alcData = readings[i].components(separatedBy: ",")
                    if alcData.count == 3 {
                        var type = String(alcData[0])
                        type = (type=="B") ? "BeerList" : type
                        type = (type=="L") ? "LiquorList" : type
                        type = (type=="W") ? "WineList" : type
                        let name = Data.applyReg(starting: alcData[1], pattern: "(?<=\\S)(')(?=\\S)", substitution: "’")
                        let abv = String(alcData[2]).filter { !"\r".contains($0) }
                        Data.masterList[name] = (type: type, abv: abv)
                        //
                        let alcohol = NSManagedObject(entity: entity, insertInto: managedContext)
                        alcohol.setValue(name, forKeyPath: "name")
                        alcohol.setValue(type, forKeyPath: "type")
                        alcohol.setValue(abv, forKeyPath: "abv")
                        do {
                            try managedContext.save()
                        } catch let error as NSError {
                            print("Could not save. \(error), \(error.userInfo)")
                        }
                    }
                }
            }
            catch let error as NSError {
                print("Error: \(error)")
            }
        }
    }
    
    static func applyReg(starting: String, pattern: String, substitution: String) -> String {
        var newString = starting
        if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
            let regString = regex.stringByReplacingMatches(in: starting, options: .withoutAnchoringBounds, range: NSMakeRange(0,starting.count), withTemplate: substitution)
            newString = regString}
        return newString
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
            }
            else if entity == Data.liquorListID {
                Data.liquorList = []
                let objects = try! managedContext.fetch(fetch) as! [LiquorList]
                for obj in objects {
                    Data.liquorList.append((name: obj.name!, abv: obj.abv!, size: obj.size!, price: obj.price!))
                }
            }
            else if entity == Data.wineListID {
                Data.wineList = []
                let objects = try! managedContext.fetch(fetch) as! [WineList]
                for obj in objects {
                    Data.wineList.append((name: obj.name!, abv: obj.abv!, size: obj.size!, price: obj.price!))
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
