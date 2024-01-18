//
//  SignInViewController.swift
//  FirebaseAuthenticationDemo
//
//  Created by Huei-Der Huang on 2023/12/28.
//

import UIKit
import GoogleSignIn

class SignInViewController: UIViewController {

    @IBOutlet weak var phoneNumberButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeUI()
    }
    
    func initializeUI() {
        phoneNumberButton.clipsToBounds = true
        phoneNumberButton.layer.cornerRadius = 10
        phoneNumberButton.layer.borderWidth = 1
        phoneNumberButton.layer.borderColor = UIColor(cgColor: CGColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 1)).cgColor
        
        emailButton.clipsToBounds = true
        emailButton.layer.cornerRadius = 10
        emailButton.layer.borderWidth = 1
        emailButton.layer.borderColor = UIColor(cgColor: CGColor(red: 246/255, green: 196/255, blue: 68/255, alpha: 1)).cgColor
        
        linkButton.clipsToBounds = true
        linkButton.layer.cornerRadius = 10
        linkButton.layer.borderWidth = 1
        linkButton.layer.borderColor = UIColor(cgColor: CGColor(red: 225/255, green: 81/255, blue: 65/255, alpha: 1)).cgColor
        
        googleButton.clipsToBounds = true
        googleButton.layer.cornerRadius = 10
        googleButton.layer.borderWidth = 1
        googleButton.layer.borderColor = UIColor(cgColor: CGColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1)).cgColor
        
        facebookButton.clipsToBounds = true
        facebookButton.layer.cornerRadius = 10
        facebookButton.layer.borderWidth = 1
        facebookButton.layer.borderColor = UIColor(cgColor: CGColor(red: 56/255, green: 116/255, blue: 203/255, alpha: 1)).cgColor
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
