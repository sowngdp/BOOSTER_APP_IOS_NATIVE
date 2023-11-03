//
//  MyRootViewController.swift
//  Booster
//
//  Created by Fy Spoti on 01/11/2023.
//

import UIKit
import FirebaseAuth

class MyRootViewController: UIViewController {

    let sceneDelegate = UIApplication.shared.connectedScenes
                    .first!.delegate as! SceneDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
        self.navigationItem.rightBarButtonItem = logoutButton
        // Do any additional setup after loading the view.
    }
    
    @objc func logoutTapped() {
      // Code để logout
      // Ví dụ:
      let firebaseAuth = Auth.auth()
      do {
        try firebaseAuth.signOut()
          self.transitionToLogin()
        // Chuyển về màn hình login
      } catch let signOutError as NSError {
        print ("Error signing out: %@", signOutError)
      }
    }
    
    func transitionToLogin() {

        sceneDelegate.setRootViewWelcome()
            
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
