//
//  Person.swift
//  Predicate
//
//  Created by Soul on 18/08/2018.
//  Copyright © 2018 Fluffy. All rights reserved.
//

import Foundation
import CoreData

enum RaceEnum: Int16 {
	case human = 0
	case goat = 1
	case skeleton = 2
	case flower = 3
}


extension Person {
	var raceEnum: RaceEnum {
		set {
			self.race = newValue.rawValue
		}
		get {
			return RaceEnum(rawValue: self.race) ?? .human // default is human if not set
		}
	}
	
	class func peopleSeed(context: NSManagedObjectContext) -> [Person] {
		
		let chara = NSEntityDescription.insertNewObject(forEntityName: "Person", into: context) as! Person
		chara.name = "Chara"
		chara.raceEnum = .human
		chara.money = 0
		chara.married = false
		chara.birthday = Date(timeIntervalSinceReferenceDate: 217418623) // 22 November 2007
		
		let flowey = NSEntityDescription.insertNewObject(forEntityName: "Person", into: context) as! Person
		flowey.name = "Flowey"
		flowey.raceEnum = .flower
		flowey.money = 0
		flowey.married = false
		flowey.birthday = Date(timeIntervalSinceReferenceDate: 185882623) // 22 November 2006
		
		let frisk = NSEntityDescription.insertNewObject(forEntityName: "Person", into: context) as! Person
		frisk.name = "Frisk"
		frisk.raceEnum = .human
		frisk.money = 100
		frisk.married = false
		frisk.birthday = Date(timeIntervalSinceReferenceDate: 217418623) // 22 November 2007
		
		let asriel = NSEntityDescription.insertNewObject(forEntityName: "Person", into: context) as! Person
		asriel.name = "Asriel"
		asriel.raceEnum = .goat
		asriel.money = 50
		asriel.married = false
		asriel.birthday = Date(timeIntervalSinceReferenceDate: 185882623) // 22 November 2006
		
		let toriel = NSEntityDescription.insertNewObject(forEntityName: "Person", into: context) as! Person
		toriel.name = "Toriel"
		toriel.raceEnum = .goat
		toriel.money = 1000
		toriel.married = true
		toriel.birthday = Date(timeIntervalSinceReferenceDate: -445269377) // 22 November 1986
		
		let asgore = NSEntityDescription.insertNewObject(forEntityName: "Person", into: context) as! Person
		asgore.name = "Asgore"
		asgore.raceEnum = .goat
		asgore.money = 100000
		asgore.married = true
		asgore.birthday = Date(timeIntervalSinceReferenceDate: -603035777) // 22 November 1981
		
		let sans = NSEntityDescription.insertNewObject(forEntityName: "Person", into: context) as! Person
		sans.name = "Sans"
		sans.raceEnum = .skeleton
		sans.money = 10
		sans.married = false
		sans.birthday = Date(timeIntervalSinceReferenceDate: -3419777) // 22 November 2000

		
		let papyrus = NSEntityDescription.insertNewObject(forEntityName: "Person", into: context) as! Person
		papyrus.name = "Papyrus"
		papyrus.raceEnum = .skeleton
		papyrus.money = 30
		papyrus.married = false
		papyrus.birthday = Date(timeIntervalSinceReferenceDate: 154346623) // 22 November 2005
		
		return [chara, flowey, frisk, asriel, toriel, asgore, sans, papyrus]
	}
}
