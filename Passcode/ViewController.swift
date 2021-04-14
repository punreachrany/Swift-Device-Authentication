//
//  ViewController.swift
//  Passcode
//
//  Created by elite on 2021/04/14.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    @IBOutlet weak var userButton: UIButton!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        //        authenticateUser()
        //        var result: Bool
        
        let result = stackOverflowKeychain()

        if result {
            self.resultLabel.text = "Passcode Success"
            print("Success")
            return
        }else{
            self.resultLabel.text = "Passcode Failed"
            print("Failed")
            return
        }
        
//        stackOverflowKeychain()
        authenticateUser()
    }
    
    func authenticateUser() {
        let context = LAContext()
        let reason = "Biometric Authntication testing !!"
        //        var authError: NSError?
        
        if #available(iOS 8.0, macOS 10.12.1, *){
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: reason) { (success, error) in
                DispatchQueue.main.async {
                    if success {
                        self.resultLabel.text = "Success"
                        print("Success")
                    }else{
                        self.resultLabel.text = "Failed"
                        print("Failed")
                        return
                    }
                }
            }
        }else{
            print("This feature is not supported.")
            self.resultLabel.text = "Not Supported"
        }
    }
    
    //    func startAuthentication() {
    //        let contet = LAContext()
    //        let reason = "Biometric Authntication testing !!"
    //        var authError: NSError?
    //        if #available(iOS 8.0, macOS 10.12.1, *) {
    //            if contet.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
    //                contet.localizedCancelTitle = "Cancel"
    //                contet.localizedFallbackTitle = ""
    //                contet.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, evaluateError in
    //                    DispatchQueue.main.async {
    //                        if success {
    //                            let alert = UIAlertController(title: "Success", message: "Successfully Authenticated", preferredStyle: .alert)
    //                            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
    //                            self.present(alert, animated: true, completion: nil)
    //                        } else {
    //                            // User did not authenticate successfully, look at error and take appropriate action
    //                            print(evaluateError?.localizedDescription)
    //                        }
    //                    }
    //                }
    //            } else {
    //                // Could not evaluate policy; look at authError and present an appropriate message to user
    //                print("Sorry!!.. Could not evaluate policy.\(authError?.localizedDescription)")
    //            }
    //        } else {
    //            print("This feature is not supported.")
    //        }
    //    }
    
    func createKeyChainItem() -> Bool {
        
        let stringData = "String Data"
        
        let theData = stringData.data(using: .utf8)
        
        let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, kSecAttrAccessibleAlways, .devicePasscode, nil)
        
        let query = [
            kSecClass as String : kSecClassGenericPassword as String,
            kSecAttrAccessControl as String : accessControl,
            kSecAttrAccount as String : "myAccount",
            kSecAttrService as String : "myService",
            kSecValueData as String : theData!
        ] as [String: Any]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == noErr || status == errSecDuplicateItem {
            print("successfully added passcode-protected item to keychain")
        }
        return status == noErr || status == errSecDuplicateItem
    }
    
    func authenticateUsingPasscode() -> Bool {
        var success = createKeyChainItem()
        if success {
            print("====================")
            print("Inside if Success ")
            print(String(success))
            print("====================")
            
            var dataTypeRef:AnyObject?
            let retrieveQuery = [
                kSecClass as String : kSecClassGenericPassword as String,
                kSecAttrAccount as String : "myAccount",
                kSecAttrService as String : "myService",
                kSecReturnData as String : kCFBooleanTrue,
                kSecMatchLimit as String : kSecMatchLimitOne
            ] as [String: Any]
            let status = SecItemCopyMatching(retrieveQuery as CFDictionary, nil)
            success = (status != noErr)
            if status == errSecUserCanceled {
                print("user canceled authentication")
            }
            print(String(success))
            return success
        }
        return success
    }
    
    func stackOverflowKeychain()->Bool {
        let secAccessControlbject: SecAccessControl = SecAccessControlCreateWithFlags(
            kCFAllocatorDefault,
            kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
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
                kSecUseOperationPrompt : "Sign in"
            ]

            var typeRef : CFTypeRef?

            let status: OSStatus = SecItemCopyMatching(query, &typeRef) //This will prompt the passcode.

            if (status == errSecSuccess)
            {
               return  true
            }else{
                return false
            }
    }
    
}

