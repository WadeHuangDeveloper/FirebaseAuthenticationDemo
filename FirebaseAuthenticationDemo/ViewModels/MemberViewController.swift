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
    
    @IBOutlet weak var profilePictureView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeUI()
        initializeAuth()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initializeAuth()
    }
    
    private func initializeUI() {
        let rightBarButtnItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(settings))
        self.navigationItem.rightBarButtonItem = rightBarButtnItem
        
        nameTextField.isEnabled = false
        emailTextField.isEnabled = false
        phoneNumberTextField.isEnabled = false
        nameTextField.text = ""
        phoneNumberTextField.text = ""
        emailTextField.text = ""
        emailLabel.text = "Email"
    }
    
    @objc
    private func settings() {
        // Move to SettingsViewController
        let controller = storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func initializeAuth() {
        guard let currentUser = Auth.auth().currentUser else {
            initializeUI()
            return
        }
        
        if let facebookUser = AccessToken.current {
            let pictureView = FBProfilePictureView(frame: CGRect(x: 0, y: 0, width: profilePictureView.frame.width, height: profilePictureView.frame.height))
            pictureView.profileID = facebookUser.userID
            profilePictureView.addSubview(pictureView)
        }
        
        nameTextField.text = currentUser.displayName
        phoneNumberTextField.text = currentUser.phoneNumber
        emailTextField.text = currentUser.email
        emailLabel.text = currentUser.isEmailVerified ? "Email ✅" : "Email"
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
