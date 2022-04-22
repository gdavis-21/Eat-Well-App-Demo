//
//  SnapshotViewController.swift
//  EatWell
//
//  Created by Grant Davis on 4/13/22.
//

import UIKit
import CoreData
import HealthKit

class SnapshotViewController: UIViewController {


    @IBOutlet var caloriesConsumedLabel: UILabel!
    @IBOutlet var caloriesBurnedLabel: UILabel!
    @IBOutlet var stepsWalkedLabel: UILabel!
    @IBOutlet var standTimeLabel: UILabel!
    @IBOutlet var greetingLabel: UILabel!
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if (HealthKitFunctions.initializeHealthKit() && HealthKitFunctions.authorizeHealthKit()) {
            
            let stepCountSampleType = HKSampleType.quantityType(forIdentifier: .stepCount)!
            let averageEnergyBurnedSampleType = HKSampleType.quantityType(forIdentifier: .activeEnergyBurned)!
            let standTimeSampleType = HKSampleType.quantityType(forIdentifier: .appleStandTime)!
            
            // Get the user's step count and update the view.
            HealthKitFunctions.getMostRecentSample(for: stepCountSampleType) {
                (sample, error) in
                
                guard let sample = sample else {
                    
                    if let error = error {
                        
                    }
                    
                    return
                }
                
                
                let stepsWalked = sample.quantity.doubleValue(for: HKUnit.count())
                self.stepsWalkedLabel.text = String(Int(stepsWalked))
                
            }
            
            // Get the user's calories burned (active) and update view.
            HealthKitFunctions.getMostRecentSample(for: averageEnergyBurnedSampleType) {
                (sample, error) in
                
                guard let sample = sample else {
                    
                    if let error = error {
                        
                    }
                    
                    return
                }
                
                
                let averageEnergyBurned = sample.quantity.doubleValue(for: HKUnit.largeCalorie())
                self.caloriesBurnedLabel.text = String(averageEnergyBurned)
                
            }
            
            // Get the user's heart rate and update the view.
            HealthKitFunctions.getMostRecentSample(for: standTimeSampleType) {
                (sample, error) in
                
                guard let sample = sample else {
                    
                    if let error = error {
                        
                    }
                    
                    return
                }
                
                
                let standTime = sample.quantity.doubleValue(for: .hour())
                self.standTimeLabel.text = String(standTime)
                
            }
            
            // Read the user's consumed calories from Core Data for today's date.
            var caloriesConsumed = 0
            for entry in fetchEntries(selectedDate: Date().formatted(date: .numeric, time: .omitted).components(separatedBy: "/")[1]) {
                if let calories =  Int(entry.calories ?? "0") {
                    caloriesConsumed += calories
                }
            }
            caloriesConsumedLabel.text = String(caloriesConsumed)
            
            let name = userDefaults.string(forKey: "Name")
            
            if (name == nil || name == "Placeholder") {
                greetingLabel.text = "Today Looks Great!"
            }
            else {
                greetingLabel.text = "Today Looks Great, \(name!)!"
            }
            
        }
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        super.viewDidAppear(true)
        
        let name = userDefaults.string(forKey: "Name")
        
        if (name == nil || name == "Placeholder") {
            greetingLabel.text = "Today Looks Great!"
        }
        else {
            greetingLabel.text = "Today Looks Great, \(name!)!"
        }
        
        if (HealthKitFunctions.initializeHealthKit() && HealthKitFunctions.authorizeHealthKit()) {
            
            let stepCountSampleType = HKSampleType.quantityType(forIdentifier: .stepCount)!
            let averageEnergyBurnedSampleType = HKSampleType.quantityType(forIdentifier: .activeEnergyBurned)!
            let standTimeSampleType = HKSampleType.quantityType(forIdentifier: .appleStandTime)!
            
            // Get the user's step count and update the view.
            HealthKitFunctions.getMostRecentSample(for: stepCountSampleType) {
                (sample, error) in
                
                guard let sample = sample else {
                    
                    if let error = error {
                        
                    }
                    
                    return
                }
                
                
                let stepsWalked = sample.quantity.doubleValue(for: HKUnit.count())
                self.stepsWalkedLabel.text = String(Int(stepsWalked))
                
            }
            
            // Get the user's calories burned (active) and update view.
            HealthKitFunctions.getMostRecentSample(for: averageEnergyBurnedSampleType) {
                (sample, error) in
                
                guard let sample = sample else {
                    
                    if let error = error {
                        
                    }
                    
                    return
                }
                
                
                let averageEnergyBurned = sample.quantity.doubleValue(for: HKUnit.largeCalorie())
                self.caloriesBurnedLabel.text = String(Int(averageEnergyBurned))
                
            }
            
            // Get the user's heart rate and update the view.
            HealthKitFunctions.getMostRecentSample(for: standTimeSampleType) {
                (sample, error) in
                
                guard let sample = sample else {
                    
                    if let error = error {
                        
                    }
                    
                    return
                }
                
                
                let standTime = sample.quantity.doubleValue(for: .hour())
                self.standTimeLabel.text = String(standTime)
                
            }
            
            // Read the user's consumed calories from Core Data for today's date.
            var caloriesConsumed = 0
            for entry in fetchEntries(selectedDate: Date().formatted(date: .numeric, time: .omitted).components(separatedBy: "/")[1]) {
                if let calories =  Int(entry.calories ?? "0") {
                    caloriesConsumed += calories
                }
            }
            caloriesConsumedLabel.text = String(caloriesConsumed)
            
        }
    }
    
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
    
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

