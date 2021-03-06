//
//  JournalViewController.swift
//  EatWell
//
//  Created by Grant Davis on 4/11/22.
//
import UIKit
import CoreData

class JournalViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // days is the array of Strings used to populate the collectionView.
    var days: [String]? = nil
    // entries is the array of Entry objects used to populate the tableView.
    var entries: [Entry]? = nil
    // selectedDateNumeric holds the date the user selects (i.e. 14).
    var selectedDate: String? = nil
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var textField: UITextField!
    @IBOutlet var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        tableView.rowHeight = 200
        
        // Get today's date (i.e. April 12, 2022)
        selectedDate = Date.now.formatted(date: .numeric, time: .omitted).components(separatedBy: "/")[1]
        
        // Set the main label to display the current date.
        label.text = Date.now.formatted(date: .abbreviated, time: .omitted)
        
        days = createDays()
        
        entries = fetchEntries(selectedDate: selectedDate)
        
        tableView.reloadData()
        collectionView.reloadData()
        
        let indexPath = (NSIndexPath(row: Int(selectedDate!)! - 1, section: 0) as IndexPath)
        // Set the current focus in the collectionView to current date.
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    
        updateCells(entries: entries, tableView: tableView)
    
    }
        
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if selectedDate == Date.now.formatted(date: .numeric, time: .omitted).components(separatedBy: "/")[1] {
            saveCells(entries: entries, tableView: tableView)
        }
    }
    
    // MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        entries!.count
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
        // Set the title of the button to day (i.e. 5).
        cell.button.setTitle(String(days![indexPath.row]), for: .normal)
        
        // Set the button's stringDate to indexPath.row (i.e. 5).
        cell.button.stringDate = String(indexPath.row)
        
        if (String(Int(cell.button.stringDate!)! + 1)) == selectedDate {
            cell.button.backgroundColor = .green
        }
        else {
            cell.button.backgroundColor = .clear
        }
        return cell
    }
    
    // MARK: - Core Data Functions
    
    func fetchEntries(selectedDate: String?) -> [Entry] {
        var entries = [Entry]()
        
        do {
            let request = Entry.fetchRequest() as NSFetchRequest<Entry>
            // Select only the entries whose 'stringDate' attribute match the selectedDate.
            let predicate = NSPredicate(format: "stringDate == %@", selectedDate!)
            request.predicate = predicate
            // Execute the query with the given predicate.
            entries = try context.fetch(request)
        }
        catch {
            print("Error: Unable to fetchRequest.")
        }
        return entries
    }
    
    // Save the cells in tableView to persisentStore
    func saveCells(entries: [Entry]?, tableView: UITableView) {
        var counter = 0
        for cell in (tableView.visibleCells as! [JournalTableViewCell]) {
            // Save the text stored in 'notes' textView.
            entries![counter].notes = cell.textView.text
            // Save the text stored in 'calories' textField.
            entries![counter].calories = cell.textField.text
            // Save the date stored in 'date' datePicker.
            entries![counter].date = cell.datePicker.date
             counter += 1
        }
        try! context.save()
    }
    
    
    // MARK: - Extra Functions
    
    // Creates an array of Strings from 1 to 30.
    func createDays() -> [String] {
        var days = [String]()
        for i in 1 ... 30 {
            days.append(String(i))
        }
        return days
    }
    
    // Update cells in tableView.
    func updateCells(entries: [Entry]?, tableView: UITableView) {
        var counter = 0
        if entries!.count > 0 && tableView.visibleCells.count > 0 {
            for cell in (tableView.visibleCells as! [JournalTableViewCell]) {
                // Update cell to reflect new calories, notes, and date.
                cell.updateValues(calories: entries![counter].calories ?? "0", notes: entries![counter].notes ?? String(counter), date: entries![counter].date ?? Date.now)
                    counter += 1
            }
            tableView.reloadData()
        }
    }
    
    // MARK: - Button Functions
        
    @IBAction func tableButtonPlus(_ sender: Any) {
        
        // If we add more than 3 cells, some of the cells will be offscreen. (problematic)
        if entries!.count < 3 {
            
            // Create a new entry object to add to tableView.
            let entry = Entry(context: context)
            // Initialize its stringDate to the current selectedDate
            entry.stringDate = selectedDate!
            // Save the object to the Store.
            try! context.save()
            // Refresh the 'entries' array.
            entries = fetchEntries(selectedDate: selectedDate)
            // Update the tableView.
            tableView.reloadData()
            
            // Modify the new cell to be empty.
            let sortedCells = (tableView.visibleCells as! [JournalTableViewCell]).sorted {
                (itemA, itemB) in
                itemA.datePicker.date > itemB.datePicker.date
            }
            let newCell = sortedCells.last
            newCell?.textField.text = "0"
            newCell?.textView.text = ""
            newCell?.datePicker.date = Date.now
            
            // Reload the tableView
            tableView.reloadData()
            
        }
        
    }

    @IBAction func collectionButtonDate(_ sender: Any) {
        
        var indexPath = NSIndexPath(row: Int(selectedDate!)! - 1, section: 0) as IndexPath
        
        // Only update display of previous cell to white if it's on screen.
        if abs(Int(selectedDate!)! - 1 - Int((sender as! JournalButton).stringDate!)!) <= 5 {
            ((collectionView.cellForItem(at: indexPath))! as! JournalCollectionViewCell).button.backgroundColor = .white
        }
        
        // Save the previous cells' values.
        if entries!.count > 0 && tableView.visibleCells.count > 0 {
            saveCells(entries: entries, tableView: tableView)
        }
        
        // Modify selectedDate to the date the user selected.
        selectedDate = days![Int((sender as! JournalButton).stringDate!)!]
        
        let textDay = Date.now.formatted(date: .abbreviated, time: .omitted).components(separatedBy: " ")
        print("\(textDay[0]) \(selectedDate), \(textDay[2])")
        label.text = "\(textDay[0]) \(selectedDate!), \(textDay[2])"
        
        indexPath = NSIndexPath(row: Int(selectedDate!)! - 1, section: 0) as IndexPath
        
        ((collectionView.cellForItem(at: indexPath))! as! JournalCollectionViewCell).button.backgroundColor = .green
        
        
        entries = fetchEntries(selectedDate: selectedDate)
        
        tableView.reloadData()
        
        print("Selected Date: \(selectedDate!)")
        print("Number of Entries: \(entries!.count)")
        print("Number of Visible Cells: \(tableView.visibleCells.count)")
        
        updateCells(entries: entries, tableView: tableView)
            
    }
}

