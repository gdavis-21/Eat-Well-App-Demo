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
    
    
    // MARK: - Extra Functions
    
    // Creates an array of Strings from 1 to 30.
    func createDays() -> [String] {
        var days = [String]()
        for i in 1 ... 30 {
            days.append(String(i))
        }
        return days
    }

    @IBAction func tableButtonPlus(_ sender: Any) {
        
        if entries!.count < 3 {
            
            // Create a new entry object to add to tableView.
            var entry = Entry(context: context)
            
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
        print("Selected Date: \(selectedDate!)")
        print("Number of Entries: \(entries!.count)")
        print("Number of Visible Cells: \(tableView.visibleCells.count)")
        
        
    }

    @IBAction func collectionButtonDate(_ sender: Any) {
        
        // Save the previous cells' values.
        var counter = 0
        // Loop over each entry in the selectedDate.
        if entries!.count > 0 && tableView.visibleCells.count > 0 {
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
        
        
        // Modify selectedDate to the date the user selected.
        selectedDate = days![Int((sender as! JournalButton).stringDate!)!]
        
        entries = fetchEntries(selectedDate: selectedDate)
        
        tableView.reloadData()
        
        print("Selected Date: \(selectedDate!)")
        print("Number of Entries: \(entries!.count)")
        print("Number of Visible Cells: \(tableView.visibleCells.count)")
        
        counter = 0
        // Loop over each entry in the selectedDate.
        if entries!.count > 0 && tableView.visibleCells.count > 0 {
            for cell in (tableView.visibleCells as! [JournalTableViewCell]) {
                // Update cell to reflect new calories, notes, and date.
                cell.updateValues(calories: entries![counter].calories ?? "0", notes: entries![counter].notes ?? String(counter), date: entries![counter].date ?? Date.now)
                counter += 1
            }
            tableView.reloadData()
            
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

}
