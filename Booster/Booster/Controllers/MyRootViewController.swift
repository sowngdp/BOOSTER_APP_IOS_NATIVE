//
//  MyRootViewController.swift
//  Booster
//
//  Created by Fy Spoti on 01/11/2023.
//

import UIKit
import FirebaseAuth
import Alamofire
import AlamofireImage


//class MyRootViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
//
//
//    var games: [Game] = []
//
//
//    func setupCollectionViewContentSize() {
//        let itemWidth: CGFloat = 150
//        let itemHeight: CGFloat = 260
//        let numberOfItemsPerRow: CGFloat = 2
//        let spacingBetweenItems: CGFloat = 10
//
//        let contentWidth = (itemWidth * numberOfItemsPerRow) + ((numberOfItemsPerRow - 1) * spacingBetweenItems)
//        let contentHeight = itemHeight
//
//        gameCollectionView.contentSize = CGSize(width: contentWidth, height: contentHeight)
//    }
//
//
//    func fetchGameAndUpDateCollectionView() {
//        MobyGamesService.share.fetchGames { result in
//            switch result {
//            case .success(let fetchedGames):
//                self.games = fetchedGames
//                DispatchQueue.main.async {
//                    self.gameCollectionView.reloadData()
//                }
//            case .failure(let error):
//                print(error.asAFError)
//            }
//        }
//    }
//
//
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return games.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = gameCollectionView.dequeueReusableCell(withReuseIdentifier: "idCell", for: indexPath) as! CollectionItemGame
//
//        let imageUrl = games[indexPath.row].sampleCover.imageURL
//
//        AF.request(imageUrl).responseImage { response in
//            switch response.result {
//            case .success(let image):
//                // Set the downloaded image to the UIImageView
//                cell.imageGame.image = image
//
//            case .failure(let error):
//                print("Image download failed: \(error)")
//            }
//        }
//
//
//        cell.nameGame.text = games[indexPath.row].title
//        print(games[1].title)
//        return cell
//    }
//
//
//
//
//    @IBOutlet weak var gameCollectionView: UICollectionView!
//
//    let sceneDelegate = UIApplication.shared.connectedScenes
//        .first!.delegate as! SceneDelegate
//
//    override func viewDidLoad() {
//
//        gameCollectionView.register(UINib(nibName: "CollectionItemGame", bundle: nil), forCellWithReuseIdentifier: "idCell")
//
//        gameCollectionView.delegate = self
//        gameCollectionView.dataSource = self
//
//        setupCollectionViewContentSize()
//        fetchGameAndUpDateCollectionView()
//
//
//
//
//        super.viewDidLoad()
//        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
//        self.navigationItem.rightBarButtonItem = logoutButton
//        // Do any additional setup after loading the view.
//
//
//    }
//
//
//    @objc func logoutTapped() {
//        // Code để logout
//        // Ví dụ:
//        AuthViewModel.share.logout() {
//            result  in
//            switch result {
//            case .success:
//                self.sceneDelegate.setRootViewWelcome()
//            case .failure(let error):
//                print("Logout error: \(error)")
//            }
//        }
//    }
//
//    /*
//     // MARK: - Navigation
//
//     // In a storyboard-based application, you will often want to do a little preparation before navigation
//     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//     // Get the new view controller using segue.destination.
//     // Pass the selected object to the new view controller.
//     }
//     */
//
//}
class MyRootViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var games: [Game] = []
    var isGridLayout = true

    @IBOutlet weak var gameCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        gameCollectionView.delegate = self
        gameCollectionView.dataSource = self

        // Đăng ký cell một lần duy nhất trong hàm viewDidLoad
        gameCollectionView.register(UINib(nibName: "CollectionItemGame", bundle: nil), forCellWithReuseIdentifier: "idCell")

        setupCollectionViewLayout(isGrid: isGridLayout)
        fetchGameAndUpDateCollectionView()

        let toggleButton = UIBarButtonItem(title: "Toggle Layout", style: .plain, target: self, action: #selector(toggleLayout))
        self.navigationItem.rightBarButtonItem = toggleButton
    }

    func setupCollectionViewLayout(isGrid: Bool) {
        let layout: UICollectionViewLayout
        if isGrid {
            let gridLayout = UICollectionViewFlowLayout()
            gridLayout.minimumInteritemSpacing = 10
            gridLayout.minimumLineSpacing = 10
            gridLayout.itemSize = CGSize(width: 150, height: 260)
            layout = gridLayout
        } else {
            let singleItemLayout = UICollectionViewFlowLayout()
            singleItemLayout.minimumInteritemSpacing = 10
            singleItemLayout.minimumLineSpacing = 10
            singleItemLayout.itemSize = CGSize(width: 300, height: 520)
            layout = singleItemLayout
        }

        gameCollectionView.collectionViewLayout = layout
    }

    func fetchGameAndUpDateCollectionView() {
        MobyGamesService.share.fetchGames { result in
            switch result {
            case .success(let fetchedGames):
                self.games = fetchedGames
                DispatchQueue.main.async {
                    self.gameCollectionView.reloadData()
                }
            case .failure(let error):
                print(error.asAFError)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "idCell", for: indexPath) as! CollectionItemGame

        let imageUrl = games[indexPath.row].sampleCover.imageURL

        AF.request(imageUrl).responseImage { response in
            switch response.result {
            case .success(let image):
                // Set the downloaded image to the UIImageView
                cell.imageGame.image = image

            case .failure(let error):
                print("Image download failed: \(error)")
            }
        }

        cell.nameGame.text = games[indexPath.row].title
        return cell
    }

    @IBAction func toggleLayout(_ sender: Any) {
        isGridLayout.toggle()
        setupCollectionViewLayout(isGrid: isGridLayout)
        gameCollectionView.reloadData()
    }


    @objc func logoutTapped() {
        AuthViewModel.share.logout() { result in
            switch result {
            case .success:
                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                    sceneDelegate.setRootViewWelcome()
                }
            case .failure(let error):
                print("Logout error: \(error)")
            }
        }
    }
}

