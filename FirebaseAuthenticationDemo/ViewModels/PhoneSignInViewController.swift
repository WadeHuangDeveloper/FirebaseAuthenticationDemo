//
//  PhoneSignInViewController.swift
//  FirebaseAuthenticationDemo
//
//  Created by Huei-Der Huang on 2023/12/28.
//

import UIKit
import FirebaseAuth

class PhoneSignInViewController: UIViewController {

    @IBOutlet weak var verificationCodeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeUI()
    }
    
    @IBAction func signIn(_ sender: Any) {
        Task {
            await signIn()
        }
    }
    
    private func initializeUI() {
        verificationCodeTextField.text = ""
        verificationCodeTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    private func signIn() async {
        do {
            // Get verificationID from user defaults
            guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {
                throw AuthenticationError.VerificationIDError
            }
            
            // Get verificationCode from user
            guard let verificationCode = verificationCodeTextField.text else {
                throw AuthenticationError.VerticationCodeError
            }
            
            // Create a credential
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationID,
                verificationCode: verificationCode
            )
            
            // Sign in with Firebase
            let result = try await Auth.auth().signIn(with: credential)
            
            // Move to view member controller
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "MemberViewController") as! MemberViewController
            self.navigationController?.pushViewController(controller, animated: true)
            
        } catch {
            let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            let okAlertAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.navigationController?.popToRootViewController(animated: true)
            }
            alertController.addAction(okAlertAction)
            self.present(alertController, animated: true)
        }
    }
}

extension PhoneSignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
