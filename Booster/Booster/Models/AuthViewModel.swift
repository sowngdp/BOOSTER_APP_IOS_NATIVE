//
//  AuthViewModel.swift
//  Booster
//
//  Created by Fy Spoti on 30/10/2023.
//

import Foundation
import FirebaseAuth

class AuthViewModel {
    
    static let share = AuthViewModel()
    
    var userSession : User?
    
    func fetchUser (){
        
    }
    
    func login(withUser user: UserModel, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: user.email!, password: user.password!) { result, error in
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
                            print(loggedInUser)
//                            self.userSession = loggedInUser
//                            self.fetchUser() // Assuming this function fetches user data
            
            print("DEBUG: Logged in successfully, (String(describing: self.userSession?.uid)).")
            completion(.success(()))
        }
    }
    
    
    func signup(withUser user: UserModel, completion: @escaping (Result<Void, Error>) -> Void) {
           Auth.auth().createUser(withEmail: user.email!, password: user.password!) { result, error in
               if let error = error {
                   print("DEBUG: Failed to signup, (error.localizedDescription)")
                   completion(.failure(error))
                   return
               }

               guard let user = result?.user else {
                   let customError = NSError(domain: "YourAppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get logged-in user"])
                   print("DEBUG: Failed to get logged-in user.")
                   completion(.failure(customError))
                   return
               }

               // Set user properties
               user.updateEmail(to: user.email!) { error in
                   if let error = error {
                       print("DEBUG: Failed to update user email, (error.localizedDescription)")
                   }
               }

               // Save user data to remote server

               completion(.success(()))
           }
       }
}
