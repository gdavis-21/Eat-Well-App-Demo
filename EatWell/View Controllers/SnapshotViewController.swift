//
//  SnapshotViewController.swift
//  EatWell
//
//  Created by Grant Davis on 4/13/22.
//

import UIKit
import CoreData
import HealthKit
import CloudKit

class SnapshotViewController: UIViewController {


    @IBOutlet var caloriesConsumedLabel: UILabel!
    @IBOutlet var caloriesBurnedLabel: UILabel!
    @IBOutlet var stepsWalkedLabel: UILabel!
    @IBOutlet var standTimeLabel: UILabel!
    
    
    var healthStore: HKHealthStore?
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if (initializeHealthKit() && authorizeHealthKit()) {
            
            let stepCountSampleType = HKSampleType.quantityType(forIdentifier: .stepCount)!
            let averageEnergyBurnedSampleType = HKSampleType.quantityType(forIdentifier: .activeEnergyBurned)!
            let standTimeSampleType = HKSampleType.quantityType(forIdentifier: .appleStandTime)!
            
            // Get the user's step count and update the view.
            getMostRecentSample(for: stepCountSampleType) {
                (sample, error) in
                
                guard let sample = sample else {
                    
                    if let error = error {
                        
                    }
                    
                    return
                }
                
                
                let stepsWalked = sample.quantity.doubleValue(for: HKUnit.count())
                self.stepsWalkedLabel.text = String(stepsWalked)
                
            }
            
            // Get the user's calories burned (active) and update view.
            getMostRecentSample(for: averageEnergyBurnedSampleType) {
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
            getMostRecentSample(for: standTimeSampleType) {
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (initializeHealthKit() && authorizeHealthKit()) {
            
            let stepCountSampleType = HKSampleType.quantityType(forIdentifier: .stepCount)!
            let averageEnergyBurnedSampleType = HKSampleType.quantityType(forIdentifier: .activeEnergyBurned)!
            let standTimeSampleType = HKSampleType.quantityType(forIdentifier: .appleStandTime)!
            
            // Get the user's step count and update the view.
            getMostRecentSample(for: stepCountSampleType) {
                (sample, error) in
                
                guard let sample = sample else {
                    
                    if let error = error {
                        
                    }
                    
                    return
                }
                
                
                let stepsWalked = sample.quantity.doubleValue(for: HKUnit.count())
                self.stepsWalkedLabel.text = String(stepsWalked)
                
            }
            
            // Get the user's calories burned (active) and update view.
            getMostRecentSample(for: averageEnergyBurnedSampleType) {
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
            getMostRecentSample(for: standTimeSampleType) {
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
    
    // Returns true if Healthkit is available on user's device initialized, false otherwise.
    func initializeHealthKit() -> Bool {
        
        // Check if user's device supports Healthkit
        if HKHealthStore.isHealthDataAvailable() {
            // Instantiate HealthStore object.
            healthStore = HKHealthStore()
            return true
        }
        else {
           return false
        }
    }
    
    // Returns true if user is prompted with Healthkit popup.
    func authorizeHealthKit() -> Bool {
        // Data types that will interact with Healthkit.
        guard let activeEnergyBurned = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned),
              let stepCount = HKObjectType.quantityType(forIdentifier: .stepCount),
              let heartRate = HKObjectType.quantityType(forIdentifier: .heartRate),
              let DOB = HKObjectType.characteristicType(forIdentifier: .dateOfBirth),
              let height = HKObjectType.quantityType(forIdentifier: .height),
              let sex = HKObjectType.characteristicType(forIdentifier: .biologicalSex),
              let weight =
                      HKObjectType.quantityType(forIdentifier: .bodyMass) else {
            print("Error 1:")
            return false
        }
        
        // Data types that will be read from Healthkit
        let toRead: Set<HKObjectType> = [activeEnergyBurned,
                                        stepCount,
                                        heartRate,
                                            DOB,
                                         height,
                                            sex,
                                            weight]
        // Data types that will be written to Healthkit.
        let toWrite: Set<HKSampleType> = []
        
        
        // Request authorization from user.
        HKHealthStore().requestAuthorization(toShare: toWrite, read: toRead) {
            (success, error) in
            
            if !success {
                // Some error has occured.
                print("Error 2:")
                return
            }
        }
        return true
    }
    
    // Generic function to load sample.
    // Source https://www.raywenderlich.com/459-healthkit-tutorial-with-swift-getting-started
    func getMostRecentSample(for sampleType: HKSampleType, completition: @escaping (HKQuantitySample?, Error?) -> Swift.Void) {
        
        // Load most recent samples.
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date(), end: Date(), options: .strictEndDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        let limit = 1
        
        let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: mostRecentPredicate, limit: limit, sortDescriptors: [sortDescriptor]) {
            (query, samples, error) in
            
            DispatchQueue.main.async {
                guard let samples = samples,
                      let mostRecentSample = samples.first as? HKQuantitySample else {
                    completition(nil, error)
                    return
                }
                completition(mostRecentSample, nil)
            }
        }
        HKHealthStore().execute(sampleQuery)
        
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

