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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // Authentication Buttons Action Function
    @IBAction func authenticationPressed(_ sender: UIButton) {
        
        let authenticationType = sender.currentTitle!
        
        let result : String
        
        if authenticationType == "Passcode" {
            result = String(passcodeAuthentication())
            self.resultLabel.text = "Passcode Authentication result \(result)"
            
        } else if authenticationType == "Biometric" {
//            result = String(biometricAuthentication())
//            self.resultLabel.text = "Biometric Authentication result \(result)"
            self.resultLabel.text = "분석 중입니다."
            
        } else {
            self.resultLabel.text = "Unknown Button"
        }
    }
    
    // Passcode Authentication
    func passcodeAuthentication() -> Bool {
        let reason = "Input your passcode to authenticate"
        
        let secAccessControlbject: SecAccessControl = SecAccessControlCreateWithFlags(
            kCFAllocatorDefault,
            kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
            .devicePasscode,
            nil
        )!
        let dataToStore = "AnyData".data(using: .utf8)!
        
        
        let insertQuery: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccessControl: secAccessControlbject,
            kSecAttrService: "PasscodeAuthentication",
            kSecValueData: dataToStore as Any,
        ]
        
        let insertStatus = SecItemAdd(insertQuery as CFDictionary, nil)
        
        
        let query: NSDictionary = [
            kSecClass:  kSecClassGenericPassword,
            kSecAttrService  : "PasscodeAuthentication",
            kSecUseOperationPrompt : reason
        ]
        
        var typeRef : CFTypeRef?
        
        let status: OSStatus = SecItemCopyMatching(query, &typeRef) //This will prompt the passcode.
        
        // Check authentication status
        if (status == errSecSuccess)
        {
            print("Authentication Succeeeded")
            return  true
        } else {
            print("Authentication failed")
            return false
        }
    }
    
//    // Biometric Authentication
//    func biometricAuthentication() -> Bool {
//
//        let context = LAContext()
//        let reason = "Biometric Authntication testing !!"
//        //        var authError: NSError?
//        //        var result : Bool = false
//
//        context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (success, error) in
//
//            DispatchQueue.main.async {
//
//
//                if success {
//
//                    print("Success")
//
//                }else{
//                    print("Failed")
//                    return
//                }
//
//            }
//
//        }
//
//        return true
//    }
    
    
    

}

