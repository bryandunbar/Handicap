//
//  Importer.swift
//  Handicap
//
//  Created by Dunbar, Bryan on 6/26/19.
//  Copyright © 2019 bdun. All rights reserved.
//

import UIKit
import CoreXLSX
import CoreData


protocol ImporterDelegate {
    func importerProgressUpdate(_ importer:Importer, progressText:String)
}

class Importer: NSObject {

    fileprivate var xls:XLSXFile!
    fileprivate var moc:NSManagedObjectContext!
    
    var delegate:ImporterDelegate?
    
    public init?(_ filePath:String, managedObjectContext:NSManagedObjectContext) {
        
        guard let file = XLSXFile(filepath: filePath) else {
            return nil
        }
        
        self.xls = file
        self.moc = managedObjectContext
    }
    
    
    func go() {
        
        do {
            if let workbook = try self.xls.parseWorkbooks().first {

                let sharedStrings = try self.xls.parseSharedStrings()
                for sheet in workbook.sheets.items {
                    
                    delegate?.importerProgressUpdate(self, progressText: "Importing \(sheet.name!)")
                    
                    let playerObj = getOrCreatePlayer(sheet.name!)
                    let ws = try self.xls.parseWorksheet(at: "xl/worksheets/sheet\(sheet.id).xml")
                    
                    
                    for (index, row) in (ws.data?.rows ?? []).enumerated() {
                        if index == 0 {
                            continue //header row
                        }
                        
                        if row.cells.count >= 4 {
                            let date:Date = row.cells[0].parseValue(sharedStrings) ?? Date()
                            let course:String = row.cells[1].parseValue(sharedStrings) ?? ""
                            let score:String = row.cells[2].parseValue(sharedStrings) ?? ""
                            let league:String = row.cells[3].parseValue(sharedStrings) ?? ""
                            let leagueArr = league.components(separatedBy: ", ")
                            
                            // Actually import
                            for sLeague in leagueArr {
                                let leagueObj = getOrCreateLeague(sLeague)
                                if !leagueObj.players.contains(playerObj) {
                                    leagueObj.players.insert(playerObj)
                                }
                                var courseObj = getOrCreateCourse(course)
                                
                                let scoreObj = NSEntityDescription.insertNewObject(forEntityName: "Score", into: self.moc) as! GHScore
                                scoreObj.value = Double(score)! as NSNumber
                                scoreObj.date = date
                                scoreObj.course = courseObj
                                scoreObj.player = playerObj
                                scoreObj.league = leagueObj
                                delegate?.importerProgressUpdate(self, progressText: "Score: \(date) [\(course)] - \(score) \(leagueArr)"
                                )
                                
                                
                            }
                            
                        }
                    }
                }
            }
            
           
        } catch  {
            print(error)
        }

    }
    
    func getOrCreatePlayer(_ playerName:String) -> GHPlayer {
        
        let nameArr = playerName.components(separatedBy: .whitespaces)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Player")
        fetchRequest.predicate = NSPredicate(format: "firstName == %@ and lastName == %@", nameArr[0], nameArr[1])
        do {
            let result = try moc.fetch(fetchRequest) as! [GHPlayer]
            if result.count > 0 {
                return result.first!
            }
        } catch {
            delegate?.importerProgressUpdate(self, progressText: "Error inGetOrCreatePlayer: \(playerName)")
        }
        
        let obj = NSEntityDescription.insertNewObject(forEntityName: "Player", into: self.moc) as! GHPlayer
        obj.firstName = nameArr[0]
        obj.lastName = nameArr[1]
        return obj
    }
    
    func getOrCreateLeague(_ leagueName:String) -> GHLeague {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "League")
        fetchRequest.predicate = NSPredicate(format: "name == %@", leagueName)
        do {
            let result = try moc.fetch(fetchRequest) as! [GHLeague]
            if result.count > 0 {
                return result.first!
            }
        } catch {
            delegate?.importerProgressUpdate(self, progressText: "Error in getOrCreateLeague: \(leagueName)")
        }
        
        // Didn't find one so create
        let obj = NSEntityDescription.insertNewObject(forEntityName: "League", into: self.moc) as! GHLeague
        obj.name = leagueName
        return obj
    }
    
    func getOrCreateCourse(_ courseAbbr:String) -> GHCourse {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Course")
        fetchRequest.predicate = NSPredicate(format: "abbreviation == %@", courseAbbr)
        do {
            let result = try moc.fetch(fetchRequest) as! [GHCourse]
            if result.count > 0 {
                return result.first!
            } 
        } catch {
            delegate?.importerProgressUpdate(self, progressText: "Error in getOrCreateCourse: \(courseAbbr)")
        }
        
        let obj = NSEntityDescription.insertNewObject(forEntityName: "Course", into: self.moc) as! GHCourse
        obj.name = courseAbbr
        obj.abbreviation = courseAbbr
        return obj
    }
    
}

extension Cell {
    
    static var referenceDate:Date = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let components = DateComponents(year: 1900, month: 1, day: 1, hour: 0, minute: 0, second: 0)
        return calendar.date(from: components)!
    }()
    
    
    func parseValue<T>(_ sharedStrings:SharedStrings) -> T? {
        
        var r:T?
        if self.type == "s" {
            r = sharedStrings.items[Int(self.value!)!].text as? T
        } else {
            
            if self.s == "1" {
                // It's a date, i think
                if let d = self.value {
                    let secondInDay = 86400
                    r = Date.init(timeInterval: TimeInterval(secondInDay) * Double(d)!, since: Cell.referenceDate) as? T
                }
            } else {
                r = self.value as? T
            }
        }
        
        return r
    }
}
