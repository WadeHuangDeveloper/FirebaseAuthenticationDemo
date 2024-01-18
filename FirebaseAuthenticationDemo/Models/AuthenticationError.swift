//
//  AuthenticationError.swift
//  FirebaseAuthenticationDemo
//
//  Created by Huei-Der Huang on 2024/1/2.
//

import Foundation

enum AuthenticationError: Error {
    case PhoneNumberError
    case VerificationIDError
    case VerticationCodeError
    case EmailError
    case PasswordError
    case ClientIDError
    case IDTokenError
    case AccessTokenError
}
