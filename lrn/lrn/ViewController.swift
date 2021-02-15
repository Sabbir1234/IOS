//
//  ViewController.swift
//  lrn
//
//  Created by Twinbit Limited on 14/2/21.
//

import UIKit

class ViewController: UIViewController {
    
    let customWorkoutChoiceArray = ["Workout Level" , "Cycle" , "Rest Interval"]
    var workoutChoiceData: [[String]] = [
        ["Beginner" , "Intermediate" , "Advance"],
        ["1","2","3","4","5"],
        ["5 sec" , "10 sec", "15 sec" , "20 sec"]
    ]
    
    
    var defaultSelection = [1,2,1]
    
    var sections = [Section]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        tableView.tableFooterView = UIView.init()
    }
    
    func setup(){
        
        for i in 0..<workoutChoiceData.count{
            
            sections.append(Section(collapsed: true, numberOfItems: workoutChoiceData[i].count))
        }
    }
}

extension ViewController: UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sections[section].collapsed!{
            return 0
        }
        return sections[section].numberOfItems!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return customWorkoutChoiceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        cell.nameLabel.text = workoutChoiceData[indexPath.section][indexPath.row]
        if !sections[indexPath.section].collapsed!{
            if defaultSelection[indexPath.section] == indexPath.row{
                cell.backgroundColor = .cyan
            }
            else{
                cell.backgroundColor = .none
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == customWorkoutChoiceArray.count - 1  {
            return 0
        }

        return 10
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defaultSelection[indexPath.section] = indexPath.row
        tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionButton = UIButton()
        
        sectionButton.setTitle(customWorkoutChoiceArray[section],
                               for: .normal)
        
        sectionButton.backgroundColor = .systemBlue
        
        sectionButton.tag = section
        
        sectionButton.addTarget(self,
                                action: #selector(self.hideSection(sender:)),
                                for: .touchUpInside)
        
        return sectionButton
    }
    
    @objc func hideSection(sender: UIButton){
        
        let section = sender.tag
        
        if sections[section].collapsed! {
           
            for i in 0..<sections.count{
                sections[i].collapsed = true
                tableView.reloadSections(IndexSet(integer: i), with: .automatic)
            }
            
            sections[section].collapsed = false
            tableView.reloadSections(IndexSet(integer: section), with: .automatic)
            
        }
        else{
            sections[section].collapsed = true
            tableView.reloadSections(IndexSet(integer: section), with: .automatic)
        }
        
    }
    
}

