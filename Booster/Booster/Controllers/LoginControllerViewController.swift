//
//  LoginControllerViewController.swift
//  Booster
//
//  Created by Fy Spoti on 03/10/2023.
//

import UIKit

class LoginControllerViewController: UIViewController {

    
    var user: UserModel = UserModel(email: "", name: "", password: "")
    let sceneDelegate = UIApplication.shared.connectedScenes
                    .first!.delegate as! SceneDelegate
    
    @IBOutlet weak var PWTF: UITextField!
    @IBOutlet weak var Hide_or_Unhide_pw: UIImageView!
    @IBOutlet weak var userNameTF: UITextField!
    var iconClick = true
    override func viewDidLoad() {
        super.viewDidLoad()
        //PWTF.isSecureTextEntry = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        Hide_or_Unhide_pw.isUserInteractionEnabled = true
        Hide_or_Unhide_pw.addGestureRecognizer(tapGestureRecognizer)

        // Do any additional setup after loading the view.
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        if iconClick == true {
            PWTF.isSecureTextEntry = false
            iconClick = false
        }else{
            PWTF.isSecureTextEntry = true
            iconClick = true
        }
        
    }
    



    @IBAction func signinButton(_ sender: Any) {
        
        self.user.email = userNameTF.text
        self.user.password = PWTF.text

        AuthViewModel.share.login(withUser: user) { [weak self]
            result in
            switch result {
            case .success:
                // Login successful
                self?.sceneDelegate.setRootViewTabbar()
            case .failure(let error):
                // Handle login failure
                print("Login error: \(error.localizedDescription)")
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
