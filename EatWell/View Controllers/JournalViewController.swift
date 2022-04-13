//
//  JournalViewController.swift
//  EatWell
//
//  Created by Grant Davis on 4/11/22.
//

import UIKit
import CoreData

class JournalViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var dayOfDate: Int? = nil
    var days: [Day]? = nil
    var selectedDay: Day? = nil
    var entries: [Entry]? = nil
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Create day objects in PersistentStore
        days = createDays()
        
        // Get today's date (i.e. April 12, 2022)
        let date = Date.now.formatted(date: .abbreviated, time: .omitted)
        
        label.text = date
        
        // Split the string to get the numerical date (i.e. 14).
        dayOfDate = Int(date.components(separatedBy: ",")[0].components(separatedBy: " ")[1])
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        tableView.rowHeight = 200
        
        selectedDay = fetchDay(selectedDate: dayOfDate!)
        
        entries = fetchEntries(selectedDate: dayOfDate!)
    }
    
    // MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        entries?.count ?? 0

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JournalTableViewCell", for: indexPath) as! JournalTableViewCell
        return cell
    }
    
    
    // MARK: - Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        days!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JournalCollectionViewCell", for: indexPath) as! JournalCollectionViewCell
        cell.button.setTitle(String(days![indexPath.row].day), for: .normal)
        
        cell.button.index = indexPath.row
        print(cell.button.index!)
        return cell
    }
    
    
    // MARK: - Extra Functions
    
    func fetchDay(selectedDate: Int) -> Day {
        var day = [Day]()
        do {
            let request = Day.fetchRequest() as NSFetchRequest<Day>
            let predicate = NSPredicate(format: "day == %d", selectedDate)
            request.predicate = predicate
            day = try context.fetch(request)
        }
        catch {
            
        }
        return day[0]
    }
    
    func fetchEntries(selectedDate: Int) -> [Entry] {
        var entries = [Entry]()
        do {
            let request = Entry.fetchRequest() as NSFetchRequest<Entry>
            let predicate = NSPredicate(format: "day == %d", selectedDate)
            request.predicate = predicate
            entries = try context.fetch(request)
        }
        catch {
            
        }
        return entries
    }
    
    // Creates an array of Days from 1 to 30.
    func createDays() -> [Day] {
        var dates = [Day]()
        
        for i in 1 ... 30 {
            let day = Day(context: context)
            day.day = Int64(i)
            dates.append(day)
        }
        return dates
    }

    @IBAction func tableButtonPlus(_ sender: Any) {
        let entry = Entry(context: context)
        entry.day = selectedDay!.day
        entries?.append(entry)
        // Update the display to include the entry.
        try! self.context.save()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    @IBAction func collectionButtonDate(_ sender: Any) {
        dayOfDate = Int(days![(sender as! JournalButton).index!].day)
        selectedDay = fetchDay(selectedDate: dayOfDate!)
        
        entries = fetchEntries(selectedDate: Int(days![(sender as! JournalButton).index!].day))
        
        for row in 0..<entries!.count {
            let indexPath = NSIndexPath(row: row, section: 0)
            let cell: JournalTableViewCell = tableView.cellForRow(at: indexPath as IndexPath) as! JournalTableViewCell
            cell.modifyValues(calories: String(entries![row].calories), notes: entries![row].notes ?? "")
            
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

