//
//  FacebookViewController.swift
//  FirebaseAuthenticationDemo
//
//  Created by Huei-Der Huang on 2023/12/28.
//

import UIKit
import FacebookLogin
import FirebaseAuth
import FacebookCore

class FacebookViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        logIn()
    }
    
    private func logIn() {
        // Sign in with Facebook
        let manager = LoginManager()
        manager.logIn(permissions: [Permission.publicProfile.name, Permission.email.name], from: self) { (result: LoginManagerLoginResult?, error: Error?) in
            if let error = error {
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let okAlertAction = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(okAlertAction)
                self.present(alertController, animated: true)
                return
            }
            
            guard let result = result,
                  let accessToken = result.token else {
                let alertController = UIAlertController(title: "Error", message: AuthenticationError.AccessTokenError.localizedDescription, preferredStyle: .alert)
                let okAlertAction = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(okAlertAction)
                self.present(alertController, animated: true)
                return
            }
            
            // Sign in with Firebase
            Task {
                await self.signIn(with: accessToken)
            }
        }
    }
    
    private func signIn(with accessToken: AccessToken) async {
        do {
            // Create a credential object
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Sign in with Firebase
            let result = try await Auth.auth().signIn(with: credential)
            
            // Move to MemberViewController
            let controller = storyboard?.instantiateViewController(withIdentifier: "MemberViewController") as! MemberViewController
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
