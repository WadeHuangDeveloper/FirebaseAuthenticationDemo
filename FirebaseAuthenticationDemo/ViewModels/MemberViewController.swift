//
//  MemberViewController.swift
//  FirebaseAuthenticationDemo
//
//  Created by Huei-Der Huang on 2023/12/28.
//

import UIKit
import FirebaseAuth
import FacebookCore

class MemberViewController: UIViewController {

    var user: User?
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeUI()
    }
    
    @IBAction func signOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.navigationController?.popToRootViewController(animated: true)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func initializeUI() {
        nameTextField.isEnabled = false
        emailTextField.isEnabled = false
        phoneNumberTextField.isEnabled = false
        
        if let user = Auth.auth().currentUser {
            nameTextField.text = user.displayName
            phoneNumberTextField.text = user.phoneNumber
            emailTextField.text = user.email
            emailLabel.text = user.isEmailVerified ? "Email ✅" : "Email"
        } else {
            nameTextField.text = ""
            phoneNumberTextField.text = ""
            emailTextField.text = ""
            emailLabel.text = "Email"
        }
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
