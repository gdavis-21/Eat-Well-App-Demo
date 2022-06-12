//
//  HealthKitFunctions.swift
//  EatWell
//
//  Created by Grant Davis on 6/11/22.
//

import Foundation
import HealthKit

class HealthKitFunctions {
    
    // Returns true if Healthkit is available on user's device initialized, false otherwise.
        static func initializeHealthKit() -> Bool {
            
            // Check if user's device supports Healthkit
            if HKHealthStore.isHealthDataAvailable() {
                // Instantiate HealthStore object.
                return true
            }
            else {
               return false
            }
        }
    
    // Returns true if user is prompted with Healthkit popup.
    static func authorizeHealthKit() -> Bool {
        // Data types that will interact with Healthkit.
        guard let activeEnergyBurned = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned),
              let stepCount = HKObjectType.quantityType(forIdentifier: .stepCount),
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
    static func getMostRecentSample(for sampleType: HKSampleType, completition: @escaping (HKQuantitySample?, Error?) -> Swift.Void) {
        
        // Load samples from today.
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/DD/YY HH:mm:ss"
        
        let date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date.now)
        
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: date, end: Date(), options: .strictEndDate)
        
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
