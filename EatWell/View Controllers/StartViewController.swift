//
//  StartViewController.swift
//  EatWell
//
//  Created by Grant Davis on 4/22/22.
//

import UIKit

class StartViewController: UIViewController {
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if userDefaults.bool(forKey: "hasAccount") {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let tabBarViewController = storyboard.instantiateViewController(withIdentifier: "tabBar")
            self.navigationController?.pushViewController(tabBarViewController, animated: true)
        // Do any additional setup after loading the view.
        }
    }
    
    @IBAction func createAccButton(_ sender: Any) {
        userDefaults.set(true, forKey: "hasAccount")
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
