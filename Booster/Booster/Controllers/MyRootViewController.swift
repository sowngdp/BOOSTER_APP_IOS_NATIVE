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
import CoreData
import PopMenu



class MyRootViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CollectionItemGameDelegate {
    
    
    
    @objc func imageTapped(at rowOfIndexPath: IndexPath) {
        performSegue(withIdentifier: "homeToDetaiVC", sender: rowOfIndexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeToDetaiVC", let rowOfIndexPath = sender as? IndexPath {
            let destinationVC = segue.destination as! DetailVC
            destinationVC.gameDetail = games[rowOfIndexPath.row]
            
            
        }
    }


    func addButtonTapped(at rowOfIndexPath: IndexPath) {
        
        //let selectedGame = gameCell
        let selectedGame = games[rowOfIndexPath.row]
        //print(selectedGame.title)
        

        let menuViewController = PopMenuViewController(actions: [
            PopMenuDefaultAction(title: "Uncategorized", didSelect: { action in
                // action is a `PopMenuAction`, in this case it's a `PopMenuDefaultAction`
                self.dismiss(animated: true)
                self.saveGameToCoreData(game: selectedGame, status: action.title!)
                
            }),
            PopMenuDefaultAction(title: "Currently playing", didSelect: { action in
                // action is a `PopMenuAction`, in this case it's a `PopMenuDefaultAction`
                self.dismiss(animated: true)
                self.saveGameToCoreData(game: selectedGame, status: action.title!)
                
            }),
            PopMenuDefaultAction(title: "Played", didSelect: { action in
                // action is a `PopMenuAction`, in this case it's a `PopMenuDefaultAction`
                self.dismiss(animated: true)
                self.saveGameToCoreData(game: selectedGame, status: action.title!)
                
            }),
            PopMenuDefaultAction(title: "To Play", didSelect: { action in
                // action is a `PopMenuAction`, in this case it's a `PopMenuDefaultAction`
                self.dismiss(animated: true)
                self.saveGameToCoreData(game: selectedGame, status: action.title!)

            })
        ])
        

        present(menuViewController, animated: true, completion: nil)
        
   
    }
    
    
    func saveGameToCoreData(game: Game, status: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        // Kiểm tra xem trò chơi với ID đã tồn tại trong Core Data hay chưa
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GameSave")
        fetchRequest.predicate = NSPredicate(format: "game_id == %d", game.gameId)
        
        do {
            let existingGames = try context.fetch(fetchRequest) as! [NSManagedObject]
            
            if let existingGame = existingGames.first {
                // Trò chơi đã tồn tại, hiển thị thông báo
                showErrorMessage("This game is already in your collection.")
            } else {
                // Trò chơi chưa tồn tại, thêm mới vào Core Data
                let gameEntity = NSEntityDescription.insertNewObject(forEntityName: "GameSave", into: context)
                gameEntity.setValue(game.gameId, forKey: "game_id")
                gameEntity.setValue(status, forKey: "status")
                gameEntity.setValue(game.sampleCover.thumbnailImageURL, forKey: "thumbnail_image")
                gameEntity.setValue(game.title, forKey: "title")
                
                // Lưu thay đổi vào Core Data
                try context.save()
                print("Game saved to Core Data")
                NotificationCenter.default.post(name: NSNotification.Name("reloadProfileData"), object: nil)
//                if let tabBarController = self.tabBarController {
//                    tabBarController.selectedIndex = 1  // Index của tab "Profile"
//                }
            }
        } catch {
            print("Error checking for existing game: \(error)")
        }
    }

    func showErrorMessage(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }

    
    var games: [Game] = []
    var isGridLayout = true
    
    @IBOutlet weak var gameCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameCollectionView.delegate = self
        gameCollectionView.dataSource = self
        
        gameCollectionView.register(UINib(nibName: "CollectionItemGame", bundle: nil), forCellWithReuseIdentifier: "idCell")
        
        setupCollectionViewLayout(isGrid: isGridLayout)
        fetchGameAndUpDateCollectionView()
        
        
        
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
        self.navigationItem.rightBarButtonItem = logoutButton
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
                print(error.asAFError!)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "idCell", for: indexPath) as! CollectionItemGame
        
        let imageUrl = games[indexPath.row].sampleCover.thumbnailImageURL
        
        AF.request(imageUrl).responseImage { response in
            switch response.result {
            case .success(let image):
                // Set the downloaded image to the UIImageView
                cell.imageGame.image = image
                
            case .failure(let error):
                print("Image download failed: \(error)")
            }
        }
        cell.rowOfIndexPath = indexPath
        //cell.gameCell = games[indexPath.row]
        let tapGestureRecognizer = UITapGestureRecognizer(target: cell, action: #selector(CollectionItemGame.imageTapped))
//        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        cell.imageGame.isUserInteractionEnabled = true
        cell.imageGame.addGestureRecognizer(tapGestureRecognizer)
        // Your action
        cell.nameGame.text = games[indexPath.row].title
        cell.delegate = self
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

