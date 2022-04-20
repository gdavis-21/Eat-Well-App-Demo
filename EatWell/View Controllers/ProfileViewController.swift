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
    @IBOutlet var ageTextField: UITextField!
    @IBOutlet var sexLabel: UILabel!
    @IBOutlet var heightLabel: UILabel!
    @IBOutlet var weightLabel: UILabel!
    
    var healthStore: HKHealthStore?
    
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let name = userDefaults.string(forKey: "Name")
        if name != nil {
            nameTextField.text = name
        }
        else {
            nameTextField.text = "Placeholder"
        }
        let age = userDefaults.string(forKey: "Age")
        if age == nil {
            ageTextField.text = "Placeholder"
        }
        else {
            ageTextField.text = age
        }
        
        // Do any additional setup after loading the view.
        
        if (initializeHealthKit() && authorizeHealthKit()) {
            
            let sex = try! healthStore?.biologicalSex().biologicalSex.rawValue
            print(sex!)
            switch (sex!) {
            case 0:
                sexLabel.text = "Unknown"
            case 1:
                sexLabel.text = "Female"
            case 2:
                sexLabel.text = "Male"
            default:
                sexLabel.text = "NA"
            }

            
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
                
                
                var height = sample.quantity.doubleValue(for: HKUnit.foot())
                self.heightLabel.text = "\(round(height * 10)/10) Feet"
                
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
        guard let height = HKObjectType.quantityType(forIdentifier: .height),
              let sex = HKObjectType.characteristicType(forIdentifier: .biologicalSex),
              let weight =
                HKObjectType.quantityType(forIdentifier: .bodyMass)
        else {
            print("Error 1:")
            return false
        }
            
        
        // Data types that will be read from Healthkit
        let toRead: Set<HKObjectType> = [
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
        
        let date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date.now)
        // Load most recent samples today.
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
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        userDefaults.set(nameTextField.text, forKey: "Name")
        
        if ageTextField.text == "Placeholder" {
            
        }
        userDefaults.set(ageTextField.text, forKey: "Age")
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
