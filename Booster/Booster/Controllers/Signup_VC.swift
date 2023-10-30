//
//  Signup_VC.swift
//  Booster
//
//  Created by Fy Spoti on 06/10/2023.
//

import UIKit

class Signup_VC: UIViewController {

    @IBOutlet weak var emailUser: UITextField!
    @IBOutlet weak var nameUser: UITextField!
    @IBOutlet weak var passwordUser: UITextField!
    
    var user: UserModel = UserModel(email: "", name: "", password: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
