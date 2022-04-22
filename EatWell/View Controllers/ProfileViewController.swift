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
        
        if (HealthKitFunctions.initializeHealthKit() && HealthKitFunctions.authorizeHealthKit()) {
            
            let healthStore = HKHealthStore()
            
            let sex = try! healthStore.biologicalSex().biologicalSex.rawValue

            switch (sex) {
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
            HealthKitFunctions.getMostRecentSample(for: heightSampleType!) {
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
            HealthKitFunctions.getMostRecentSample(for: weightSampleType!) {
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
