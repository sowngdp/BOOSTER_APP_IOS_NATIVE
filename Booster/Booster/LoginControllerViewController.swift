//
//  LoginControllerViewController.swift
//  Booster
//
//  Created by Fy Spoti on 03/10/2023.
//

import UIKit

class LoginControllerViewController: UIViewController {

    
    
    @IBOutlet weak var PWTF: UITextField!
    @IBOutlet weak var Hide_or_Unhide_pw: UIImageView!
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
