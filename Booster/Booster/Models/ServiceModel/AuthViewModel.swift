//
//  AuthViewModel.swift
//  Booster
//
//  Created by Fy Spoti on 26/10/2023.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseAuth


class AuthViewModel
{
    
    func fetchUser () {
        
    }
    
    
    var userSession: User?
    
    
    
    
    func login(withUser user: UserInputData, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: user.email, password: user.password) { result, error in
            if let error = error {
                print("DEBUG: Failed to login, (error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let loggedInUser = result?.user else {
                let customError = NSError(domain: "YourAppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get logged-in user"])
                print("DEBUG: Failed to get logged-in user.")
                completion(.failure(customError))
                return
            }

            self.userSession = loggedInUser
            self.fetchUser() // Assuming this function fetches user data

            print("DEBUG: Logged in successfully, (String(describing: self.userSession?.uid)).")
            completion(.success(()))
        }
    }
 }
