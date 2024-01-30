//
//  EmailPasswordViewController.swift
//  FirebaseAuthenticationDemo
//
//  Created by Huei-Der Huang on 2023/12/28.
//

import UIKit
import FirebaseAuth

class EmailPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var primaryButton: UIButton!
    @IBOutlet weak var secondaryButton: UIButton!
    @IBOutlet weak var showPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeUIWithLoginMode()
    }
    
    @IBAction func togglePassword(_ sender: Any) {
        let image = passwordTextField.isSecureTextEntry ? UIImage(systemName: "eye.slash") : UIImage(systemName: "eye")
        showPasswordButton.setImage(image, for: .normal)
        passwordTextField.isSecureTextEntry.toggle()
    }
    
    @IBAction func primary(_ sender: Any) {
        if primaryButton.titleLabel?.text == "Login" {
            signIn()
        } else {
            createUser()
        }
    }
    
    @IBAction func secondary(_ sender: Any) {
        if primaryButton.titleLabel?.text == "Login" {
            initializeUIWithCreateMode()
        } else {
            initializeUIWithLoginMode()
        }
    }
    
    private func initializeUIWithLoginMode() {
        emailTextField.text = "wadehuangdeveloper@gmail.com"
        passwordTextField.text = "000000"
        passwordTextField.isSecureTextEntry = true
        
        primaryButton.setTitle("Login", for: .normal)
        secondaryButton.setTitle("Create a new user", for: .normal)
    }
    
    private func initializeUIWithCreateMode() {
        emailTextField.text = "wadehuangdeveloper@gmail.com"
        passwordTextField.text = "000000"
        passwordTextField.isSecureTextEntry = true
        
        primaryButton.setTitle("Create a new user", for: .normal)
        secondaryButton.setTitle("Login", for: .normal)
    }
    
    private func signIn() {
        Task {
            do {
                // Get Email from user
                guard let email = emailTextField.text else {
                    throw AuthenticationError.EmailError
                }
                
                // Get password from user
                guard let password = passwordTextField.text else {
                    throw AuthenticationError.PasswordError
                }
                
                // Sign in with Firebase
                let result = try await Auth.auth().signIn(withEmail: email, password: password)
                
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
    
    private func createUser() {
        Task {
            do {
                // Get Email from user
                guard let email = emailTextField.text else {
                    throw AuthenticationError.EmailError
                }
                
                // Get password from user
                guard let password = passwordTextField.text else {
                    throw AuthenticationError.PasswordError
                }
                
                // Create user with Firebase
                let result = try await Auth.auth().createUser(withEmail: email, password: password)
                
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
}

extension EmailPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
