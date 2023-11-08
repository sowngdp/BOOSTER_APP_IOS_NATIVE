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
        MobyGamesService.share.fetchGames { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let games):
                    // Xử lý mảng games
                    print(games[0].title)
                case .failure(let error):
                    // Xử lý lỗi
                    print(error.localizedDescription)
                }
            }
        }

    }
    
    @objc func logoutTapped() {
      // Code để logout
      // Ví dụ:
        AuthViewModel.share.logout() {
            result  in
            switch result {
            case .success:
                self.sceneDelegate.setRootViewWelcome()
            case .failure(let error):
                print("Logout error: \(error)")
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
