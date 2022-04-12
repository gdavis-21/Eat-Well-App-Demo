//
//  JournalViewController.swift
//  EatWell
//
//  Created by Grant Davis on 4/11/22.
//

import UIKit

class JournalViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var dates = createDates()
    
    var entries = [String]()
    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        tableView.rowHeight = 200
    }
    
    // MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        entries.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JournalTableViewCell", for: indexPath) as! JournalTableViewCell
        return cell
    }
    
    // MARK: - Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JournalCollectionViewCell", for: indexPath) as! JournalCollectionViewCell
        cell.button.setTitle(String(dates[indexPath.row]), for: .normal)
        return cell
    }
    
    // MARK: - Extra Functions
    
    // Creates an array of integers from 1 to 30.
    static func createDates() -> [Int] {
        var dates = [Int]()
        
        for i in 1 ... 30 {
            dates.append(i)
        }
        return dates
    }

    @IBAction func tableButtonPlus(_ sender: Any) {
        entries.append(String())
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

