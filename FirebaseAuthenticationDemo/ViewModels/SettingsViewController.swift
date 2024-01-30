//
//  SettingsViewController.swift
//  FirebaseAuthenticationDemo
//
//  Created by Huei-Der Huang on 2024/1/22.
//

import UIKit
import FirebaseAuth
import os

enum Settings {
    case VerifyEmail
    case UpdateName
    case UpdateEmail
    case UpdatePassword
    case ResetPassword
    case SignOut
    case Delete
}

extension Settings: CustomStringConvertible {
    public var description: String {
        switch self {
        case .VerifyEmail: return "Verify Email"
        case .UpdateName: return "Update Name"
        case .UpdateEmail: return "Update Email"
        case .UpdatePassword: return "Update Password"
        case .ResetPassword: return "Reset Password"
        case .SignOut: return "Sign Out"
        case .Delete: return "Delete"
        }
    }
}


class SettingsViewController: UIViewController {
    
    private var password: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func vertifyEmail(_ sender: Any) {
        self.verifyEmail()
    }
    
    @IBAction func updateName(_ sender: Any) {
        let alertController = UIAlertController(title: Settings.UpdateName.description, message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            
        }
        let updateAlertAction = UIAlertAction(title: "Update", style: .default) { _ in
            if let textField = alertController.textFields?.first,
               let input = textField.text {
                self.updateNewName(input)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(updateAlertAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func updateEmail(_ sender: Any) {
        let alertController = UIAlertController(title: Settings.UpdateEmail.description, message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            
        }
        let updateAlertAction = UIAlertAction(title: "Update", style: .default) { _ in
            if let textField = alertController.textFields?.first,
               let input = textField.text {
                self.updateNewEmail(input)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(updateAlertAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func updatePassword(_ sender: Any) {
        let alertController = UIAlertController(title: Settings.UpdatePassword.description, message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.isSecureTextEntry = true
        }
        let updateAlertAction = UIAlertAction(title: "Update", style: .default) { _ in
            if let textField = alertController.textFields?.first,
               let input = textField.text {
                self.updateNewPassword(input)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(updateAlertAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func resetPassword(_ sender: Any) {
        let alertController = UIAlertController(title: Settings.ResetPassword.description, message: nil, preferredStyle: .alert)
        let resetAlertAction = UIAlertAction(title: "Reset", style: .destructive) { _ in
            if let textField = alertController.textFields?.first,
               let input = textField.text {
                self.resetNewPassword(with: input)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(resetAlertAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func signOut(_ sender: Any) {
        signOut()
    }
    
    @IBAction func deleteAccount(_ sender: Any) {
        let alertController = UIAlertController(title: Settings.Delete.description, message: nil, preferredStyle: .alert)
        let updateAlertAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.deleteUser()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(updateAlertAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func succeededAlert(with title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAlertAction = UIAlertAction(title: "OK", style: .default) { _ in
            if title.contains(Settings.SignOut.description) || title.contains(Settings.Delete.description) {
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
        alertController.addAction(okAlertAction)
        present(alertController, animated: true)
    }
    
    private func failedAlert(with title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAlertAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAlertAction)
        present(alertController, animated: true)
    }
    
    private func verifyEmail() {
        Task {
            do {
                try await Auth.auth().currentUser?.sendEmailVerification()
                
                os_log("sendEmailVerification succeeded")
                succeededAlert(with: "\(Settings.VerifyEmail.description) Succeeded", message: nil)
            } catch {
                os_log("sendEmailVerification failed: %@", error.localizedDescription)
                failedAlert(with: "\(Settings.VerifyEmail.description) Failed", message: error.localizedDescription)
            }
        }
    }
    
    private func updateNewName(_ displayName: String) {
        Task {
            do {
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = displayName
                try await changeRequest?.commitChanges()
                
                os_log("commitChanges succeeded")
                succeededAlert(with: "\(Settings.UpdateName.description) Succeeded", message: nil)
            } catch {
                os_log("commitChanges failed: %@", error.localizedDescription)
                failedAlert(with: "\(Settings.UpdateName.description) Failed", message: error.localizedDescription)
            }
        }
    }
    
    private func updateNewEmail(_ email: String) {
        Task {
            do {
                try await Auth.auth().currentUser?.sendEmailVerification(beforeUpdatingEmail: email)
                
                os_log("sendEmailVerification succeeded")
                succeededAlert(with: "\(Settings.UpdateEmail.description) Succeeded", message: "Please click link in your Email to enable")
            } catch {
                os_log("sendEmailVerification failed: %@", error.localizedDescription)
                failedAlert(with: "\(Settings.UpdateEmail.description) Failed", message: error.localizedDescription)
            }
        }
    }
    
    private func updateNewPassword(_ password: String) {
        Task {
            do {
                try await Auth.auth().currentUser?.updatePassword(to: password)
                
                os_log("updatePassword succeeded")
                succeededAlert(with: "\(Settings.UpdatePassword.description) Succeeded", message: nil)
            } catch {
                os_log("updatePassword failed: %@", error.localizedDescription)
                failedAlert(with: "\(Settings.UpdatePassword.description) Failed", message: error.localizedDescription)
            }
        }
    }
    
    private func resetNewPassword(with email: String) {
        Task {
            do {
                try await Auth.auth().sendPasswordReset(withEmail: email)
                
                os_log("sendPasswordReset succeeded")
                succeededAlert(with: "\(Settings.ResetPassword.description) Succeeded", message: nil)
            } catch {
                os_log("sendPasswordReset failed: %@", error.localizedDescription)
                failedAlert(with: "\(Settings.ResetPassword.description) Failed", message: error.localizedDescription)
            }
        }
    }
    
    private func signOut() {
        Task {
            do {
                try Auth.auth().signOut()
                
                os_log("signOut succeeded")
                succeededAlert(with: "\(Settings.SignOut.description) Succeeded", message: nil)
            } catch {
                os_log("signOut failed: %@", error.localizedDescription)
                failedAlert(with: "\(Settings.SignOut.description) Failed", message: error.localizedDescription)
            }
        }
    }
    
    private func deleteUser() {
        Task {
            do {
                try await Auth.auth().currentUser?.delete()
                
                os_log("delete succeeded")
                succeededAlert(with: "\(Settings.Delete.description) Succeeded", message: nil)
            } catch {
                os_log("delete failed: %@", error.localizedDescription)
                failedAlert(with: "\(Settings.Delete.description) Failed", message: error.localizedDescription)
            }
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
