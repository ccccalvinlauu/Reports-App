//
//  TableViewController.swift
//  Assignment1
//
//  Created by lau tszchung on 9/11/2018.
//  Copyright © 2018 lau tszchung. All rights reserved.
//

import UIKit
import CoreData

//Global var
var list = [Title]()
var ReportsData = [Report]()
var TitleSelected = ""

class TableViewController: UITableViewController {
    
    //field
    
    var YearArr = [String]()
    var arr = [String]()
    var TitleArr = [[String]]()
    var myindex = 0
    var count = 0
    var number = 0
    var repeated = false
    let wait = DispatchGroup()
    
    //function that fetch data from Core Data Container
    func fetchData() {
        //Declare a fetchRequest
        let fetchRequest : NSFetchRequest<Title> = Title.fetchRequest()
        do{
            //Get the Data from Core Data
            list.removeAll()
            list = try Favourite.context.fetch(fetchRequest)
        }catch{
            print(error)
        }
        //When the list(Core Data) is not empty, set the value of a Boolean in ReportData, indicates it favourited
        if(!list.isEmpty){
            for n in 0...list.count-1{
                for c in 0...ReportsData.count-1{
                    if(ReportsData[c].title == list[n].title){
                        ReportsData[c].hasfavourited = true
                    }
                }
            }
        }
    }
    
    //function called when the star button is clicked, call from Cell Info
    func SetCell(cell:UITableViewCell){
        //Get the index of the cell clicked
        guard let indexpathClicked = tableView.indexPath(for: cell) else {return}
        //Get the tile of the cell
        let name = TitleArr[indexpathClicked.first!][indexpathClicked.last!]
        //Gert the index of the title in ReportData
        myindex = ReportsData.index(where: { $0.title == name })!
        
        //Check if the list(Core Data) contains the report that is clicked
        for item in list {
            //condition when it is saved, remove it from Core Data
            if item.title == name{
                Favourite.context.delete(item)
                Favourite.saveContext()
                repeated = true
                ReportsData[myindex].hasfavourited = false
                
            }
        }
        
        //condition when it is not repeated, save it into Core Data
        
        if(!repeated){
            let titlesaved = Title(context: Favourite.context)
            titlesaved.title = name
            Favourite.saveContext()
            list.append(titlesaved)
        }
        repeated = false
        //fetch and reload
        self.fetchData()
        self.tableView.reloadData()
    }

    
    //function that will run in every visit of this view
    override func viewDidAppear(_ animated: Bool) {
        //DispatchGroup, wait until Retrieve JSON data is finishd
        wait.notify(queue: .main) {
            //fetch data from Core Data
            self.fetchData()
            //Reload table view
            self.tableView.reloadData()
        }
        
        
    }

    //function viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set TableView
        tableView.register(CellInfo.self, forCellReuseIdentifier: "Cell")
        //DispatchGroup(enter),start to Retrieve Data from JSON by the struct Report
        wait.enter()
        Report.details() { (results:[Report]?) in
            if let Data = results {
                ReportsData = Data
                //Sort thr array by its year descendingly
                ReportsData = ReportsData.sorted(by: { $0.year > $1.year })
                //DispatchGroup(leave), Confirm Data are all retrieved from JSON
                self.wait.leave()
                //Var YearArr, stores all distinct years
                for n in 0...ReportsData.count-1{
                    if !self.YearArr.contains(ReportsData[n].year){
                        self.YearArr.append(ReportsData[n].year)
                    }
                }
                //Sort the YearArr by year
                self.YearArr = self.YearArr.sorted(by: { $0 > $1 })
                
                //Var TitleArr, 2-D array stores all the title by year
                for item in ReportsData{
                    
                    if item.year == self.YearArr[self.count]{
                        self.arr.append(item.title)
                    } else {
                        self.TitleArr.append(self.arr)
                        self.count+=1
                        self.arr.removeAll()
                        self.arr.append(item.title)
                        
                    }
                }
                self.TitleArr.append(self.arr)
                
                
                //fetch Data from Core Data
                self.fetchData()
                //Reload table view
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Number of years in the array
        return YearArr.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Number of reports in each year
        return TitleArr[section].count
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //Year
        return self.YearArr[section]
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //cast as custom cell, init in Cell Info
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CellInfo
        cell.detailTextLabel?.textColor = .white
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 10)
        cell.textLabel?.textColor = .white
        
        let name = TitleArr[indexPath.section][indexPath.row]
        let myindex = ReportsData.index(where: { $0.title == name })!
        let contact = ReportsData[myindex]
        
        cell.link = self
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.text = TitleArr[indexPath.section][indexPath.row]
        
        cell.detailTextLabel?.text = ReportsData[myindex].authors
        
        //Set the color of the star button of the cell
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.lineBreakMode = .byWordWrapping
        cell.accessoryView?.tintColor = contact.hasfavourited ? UIColor.yellow : .lightGray
        return cell
    }
    
    //Action when the cell is clicked
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = TitleArr[indexPath.section][indexPath.row]
        let number = ReportsData.index(where: { $0.title == name })
        //Set the global value to the title that is selected
        TitleSelected = name
        self.number = number!
        //perform Segue to View Controller
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    //Setting value in the destination of the segue,(ViewContorller)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ViewController
        vc.myindex = number
    }
    
    


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
