//
//  EmailLinkViewController.swift
//  FirebaseAuthenticationDemo
//
//  Created by Huei-Der Huang on 2023/12/28.
//

import UIKit
import FirebaseAuth

class EmailLinkViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeUI()

        if let emailLink = UserDefaults.standard.string(forKey: "EmailLink") {
            Task {
                await signIn(emailLink)
            }
        }
    }
    
    @IBAction func sendLink(_ sender: Any) {
        Task {
            await sendSignInLink()
        }
    }
    
    func initializeUI() {
        emailTextField.text = "wadehuangdeveloper@gmail.com"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func sendSignInLink() async {
        do {
            // Get Email from user
            guard let email = emailTextField.text else {
                throw AuthenticationError.EmailError
            }
            UserDefaults.standard.set(email, forKey: "Email")
            
            // Create ActionCodeSettings object
            let actionCodeSettings = ActionCodeSettings()
            actionCodeSettings.url = URL(string: "https://demo.com")
            actionCodeSettings.handleCodeInApp = true
            actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
            
            // Sign in with Firebase
            try await Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings)
            
            // Succeeded
            let alertController = UIAlertController(title: "Succeeded", message: "Please check your Email", preferredStyle: .alert)
            let okAlertAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAlertAction)
            self.present(alertController, animated: true)
            
        } catch {
            let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            let okAlertAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAlertAction)
            self.present(alertController, animated: true)
        }
    }
    
    func signIn(_ emailLink: String) async {
        do {
            guard let email = UserDefaults.standard.string(forKey: "Email") else { return }
            
            // Sign in with Firebase
            let result = try await Auth.auth().signIn(withEmail: email, link: emailLink)
            
            // Move to member view controller
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "MemberViewController") as! MemberViewController
            self.navigationController?.pushViewController(controller, animated: true)
            
        } catch {
            let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            let okAlertAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAlertAction)
            self.present(alertController, animated: true)
        }
    }
}

extension EmailLinkViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
