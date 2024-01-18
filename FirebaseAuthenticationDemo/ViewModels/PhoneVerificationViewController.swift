//
//  PhoneVerificationViewController.swift
//  FirebaseAuthenticationDemo
//
//  Created by Huei-Der Huang on 2023/12/28.
//

import UIKit
import FirebaseAuth

class PhoneVerificationViewController: UIViewController {

    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeUI()
    }
    
    @IBAction func verify(_ sender: Any) {
        Task {
            await verifyPhoneNumber()
        }
    }
    
    private func initializeUI() {
        phoneNumberTextField.delegate = self
        phoneNumberTextField.text = ""
        phoneNumberTextField.placeholder = "+886"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func verifyPhoneNumber() async {
        do {
            // Get phone number from user
            guard let phoneNumber = phoneNumberTextField.text,
                  phoneNumber != "+886" else {
                throw AuthenticationError.PhoneNumberError
            }
            
            // Verify phone number
            let verificationID = try await PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil)
            
            // Sign in using the verificationID and the code sent to the user
            // Save to local
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            
            // Move to sign in with phone number view controller
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "PhoneSignInViewController") as! PhoneSignInViewController
            self.navigationController?.pushViewController(controller, animated: true)
        } catch {
            let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            let okAlertAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAlertAction)
            self.present(alertController, animated: true)
        }
    }
}

extension PhoneVerificationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = "+886"
    }
}

