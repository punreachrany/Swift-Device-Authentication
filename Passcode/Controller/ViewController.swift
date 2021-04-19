//
//  ViewController.swift
//  Passcode
//
//  Created by elite on 2021/04/14.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    @IBOutlet weak var passcodeButton: UIButton!
    @IBOutlet weak var biometricButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    
    var authResult: Bool = false
    var passcode = Passcode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        _ = passcode.deviceHasPasscode()
        
    }
    
    // Authentication Buttons Action Function
    @IBAction func authenticationPressed(_ sender: UIButton) {
        
        let authenticationType = sender.currentTitle!
        
        let result : String
        
        if authenticationType == "Passcode" {
//            result = String(passcodeAuthentication())
            result = String(self.passcode.passcodeAuthentication())
            self.resultLabel.text = "Passcode Authentication result \(result)"
            
        } else if authenticationType == "Biometric" {
            print(String(authResult))
            
            biometricAuthentication(authCompletion)
            print(String(authResult))
            
        } else {
            self.resultLabel.text = "Unknown Button"
        }
        
        //        print("Finish")
    }
    
    // Biometric Authentication
    func biometricAuthentication(_ completion: @escaping (Bool) -> Void) {
        
        let context = LAContext()
        let reason = "Biometric Authntication testing !!"
        var error : NSError?
        
        // Remove Enter passcode button
        context.localizedFallbackTitle = ""
        //        var authError: NSError?
        //        var result : Bool = false
        
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (success, biometricError) in
                DispatchQueue.main.async { [unowned self] in
                    self.authResult =  success
                    if success {
                        completion(true)
                        
                    }else{
                        print("error: \(String(describing: biometricError))")
                        completion(false)
                        return
                    }
                }
                
            }
        }else {
            print(String(describing: error))
        }
        
        
    }
    
    func authCompletion(result : Bool) {
        self.authResult = result
        self.resultLabel.text = "Biometric Authentication result \(String(self.authResult))"
        
    }
    
}

