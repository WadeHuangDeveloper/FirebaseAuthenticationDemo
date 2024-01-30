//
//  GoogleViewController.swift
//  FirebaseAuthenticationDemo
//
//  Created by Huei-Der Huang on 2023/12/28.
//

import UIKit
import FirebaseCore
import GoogleSignIn
import FirebaseAuth

class GoogleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            await signIn()
        }
    }
    
    private func signIn() async {
        guard let app = FirebaseApp.app(),
              let clientID = app.options.clientID else {
            print(AuthenticationError.ClientIDError)
            return
        }
        
        // Create Google Sign In configuration object.
        let configuration = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = configuration
        
        // Start the sign in flow
        do {
            // Sign in with Google
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: self)
            
            // Create a credential object for Google Auth
            let user = userAuthentication.user
            guard let idToken = user.idToken else {
                throw AuthenticationError.IDTokenError
            }
            let accessToken = user.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            
            // Sign in with Firebase
            let result = try await Auth.auth().signIn(with: credential)
            
            // Move to member view controller
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
