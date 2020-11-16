//
//  CoreDataPersonViewController.swift
//  Predicate
//
//  Created by Soul on 18/08/2018.
//  Copyright © 2018 Fluffy. All rights reserved.
//

import UIKit
import CoreData

class PersonViewController: UIViewController {
	
	var people: [Person] = []
	@IBOutlet weak var tableView: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.tableView.register(UINib(nibName: String(describing: PersonTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: PersonTableViewCell.self))
		self.tableView.rowHeight = UITableViewAutomaticDimension
		self.tableView.estimatedRowHeight = 94.0
		
		self.tableView.dataSource = self
		self.tableView.delegate = self
		
    }

	override func viewWillAppear(_ animated: Bool) {
		self.fetchAllRecords()
		self.tableView.reloadData()
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// MARK: IBAction
	
	@IBAction func seedTapped(_ sender: Any) {
		clearDataAndSeed()
		self.tableView.reloadData()
	}
	
	@IBAction func filterTapped(_ sender: Any) {
		let sheet = UIAlertController(title: "Filter", message: nil, preferredStyle: .actionSheet)
		let reset = UIAlertAction(title: "Reset", style: .default, handler: { action in
			self.fetchAllRecords()
			self.tableView.reloadData()
		})
		
		let inArrayFilter = UIAlertAction(title: "race IN [0, 2]", style: .default, handler: { action in
			self.inArrayFilter()
			self.tableView.reloadData()
		})
		
		let beginsWithFilter = UIAlertAction(title: "name BEGINSWITH 'AS'", style: .default, handler: { action in
			self.beginsWithFilter()
			self.tableView.reloadData()
		})
		
		let reusableFilter = UIAlertAction(title: "Reusable BEGINSWITH", style: .default, handler: { action in
			self.reusableFilter()
			self.tableView.reloadData()
		})
		
		let wildcardFilter = UIAlertAction(title: "Wildcard LIKE '*riel'", style: .default, handler: { action in
			self.wildcardFilter()
			self.tableView.reloadData()
		})
		
		let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		
		sheet.addAction(cancel)
		sheet.addAction(reset)
		sheet.addAction(inArrayFilter)
		sheet.addAction(beginsWithFilter)
		sheet.addAction(reusableFilter)
		sheet.addAction(wildcardFilter)
		
		self.present(sheet, animated: true, completion: nil)
	}
	
	
	// MARK: Core Data Operation
	
	private func clearDataAndSeed() {
		guard let appDelegate =
			UIApplication.shared.delegate as? AppDelegate else {
				return
		}
		
		let context = appDelegate.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Person.self))
		
		// delete all records from Person entity
		let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
		
		do {
			try context.execute(deleteRequest)
		} catch let error as NSError {
			print("Could not delete all data. \(error), \(error.userInfo)")
			return
		}
		
		// seed records
		let seed = Person.peopleSeed(context: context)
		do {
			try context.save()
			people = seed
		} catch let error as NSError {
			print("Could not save. \(error), \(error.userInfo)")
		}
	}
	
	private func fetchAllRecords() {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			return
		}
		
		let managedContext = appDelegate.persistentContainer.viewContext
		
		let fetchRequest = NSFetchRequest<Person>(entityName: "Person")
		
		do {
			people = try managedContext.fetch(fetchRequest)
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
		}
	}
	
	private func inArrayFilter() {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			return
		}
		
		let managedContext = appDelegate.persistentContainer.viewContext
		
		let selectedRaces = [RaceEnum.human.rawValue, RaceEnum.skeleton.rawValue]
		
		let fetchRequest = NSFetchRequest<Person>(entityName: "Person")
		fetchRequest.predicate = NSPredicate(format: "race IN %@", selectedRaces)
		do {
			people = try managedContext.fetch(fetchRequest)
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
		}
	}
	
	private func beginsWithFilter() {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			return
		}
		
		let managedContext = appDelegate.persistentContainer.viewContext
		
		let fetchRequest = NSFetchRequest<Person>(entityName: "Person")
		fetchRequest.predicate = NSPredicate(format: "name BEGINSWITH 'As'")
		do {
			people = try managedContext.fetch(fetchRequest)
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
		}
	}
	
	private func reusableFilter(){
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			return
		}
		
		// Persons' name : ["Asriel", "Asgore", "Toriel", "Frisk", "Flowey"]
		let context = appDelegate.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<Person>(entityName: "Person")
		
		let reusablePredicate = NSPredicate(format: "name BEGINSWITH $startingName")
		
		fetchRequest.predicate = reusablePredicate.withSubstitutionVariables(["startingName" : "As"])
		
		do {
			people = try context.fetch(fetchRequest)
			// ["Asriel", "Asgore"]
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
		}
		
		// reuse the predicate with a different starting name
		fetchRequest.predicate = reusablePredicate.withSubstitutionVariables(["startingName" : "F"])
		
		do {
			people += try context.fetch(fetchRequest)
			// ["Asriel", "Asgore", "Flowey", "Frisk"]
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
		}
	}
	
	private func wildcardFilter() {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			return
		}
		
		let managedContext = appDelegate.persistentContainer.viewContext
		
		let fetchRequest = NSFetchRequest<Person>(entityName: "Person")
		
		// name has zero or more characters in front of 'riel'
		// [Asriel, Toriel]
		fetchRequest.predicate = NSPredicate(format: "name LIKE %@", "*riel")
		do {
			people = try managedContext.fetch(fetchRequest)
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
		}
	}
}

extension PersonViewController : UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return people.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PersonTableViewCell.self), for: indexPath) as! PersonTableViewCell
		let person = people[indexPath.row]
		cell.configureWith(person: person)
		return cell
	}
}

extension PersonViewController : UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
