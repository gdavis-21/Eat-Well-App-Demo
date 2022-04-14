//
//  ProfileViewController.swift
//  EatWell
//
//  Created by Grant Davis on 4/14/22.
//

import UIKit
import HealthKit

class ProfileViewController: UIViewController {
    

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var sexLabel: UILabel!
    @IBOutlet var heightLabel: UILabel!
    @IBOutlet var weightLabel: UILabel!
    
    var healthStore: HKHealthStore?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if (initializeHealthKit() && authorizeHealthKit()) {
            
//            let DOBString = try! healthStore?.dateOfBirthComponents().date?.formatted(date: .numeric, time: .omitted)
//            ageLabel.text = DOBString
//            try! healthStore?.dateOfBirthComponents()
            let sex = try! healthStore?.biologicalSex().biologicalSex.rawValue
            sexLabel.text = String(sex!)
            let heightSampleType = HKSampleType.quantityType(forIdentifier: .height)
            let weightSampleType = HKSampleType.quantityType(forIdentifier: .bodyMass)
            
            // Get the user's height update view.
            getMostRecentSample(for: heightSampleType!) {
                (sample, error) in
                
                guard let sample = sample else {
                    
                    if let error = error {
                        
                    }
                    
                    return
                }
                
                
                let height = sample.quantity.doubleValue(for: HKUnit.foot())
                self.heightLabel.text = String(height)
                
            }
            
            // Get the user's weight and update view.
            getMostRecentSample(for: weightSampleType!) {
                (sample, error) in
                
                guard let sample = sample else {
                    
                    if let error = error {
                        
                    }
                    
                    return
                }
                
                
                let weight = sample.quantity.doubleValue(for: HKUnit.pound())
                self.weightLabel.text = String(weight)
                
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
        guard let DOB = HKObjectType.characteristicType(forIdentifier: .dateOfBirth),
              let height = HKObjectType.quantityType(forIdentifier: .height),
              let sex = HKObjectType.characteristicType(forIdentifier: .biologicalSex),
              let weight =
                HKObjectType.quantityType(forIdentifier: .bodyMass)
        else {
            print("Error 1:")
            return false
        }
            
        
        // Data types that will be read from Healthkit
        let toRead: Set<HKObjectType> = [DOB,
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
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    }
}
