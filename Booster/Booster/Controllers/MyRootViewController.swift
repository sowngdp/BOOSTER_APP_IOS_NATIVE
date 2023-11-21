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



class MyRootViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CollectionItemGameDelegate {
    func addButtonTapped(at rowOfIndexPath: Int) {
        
        let selectedGame = games[rowOfIndexPath]
        print(selectedGame.title)
        saveGameToCoreData(game: selectedGame)
        
    }
    
    
    
    
    func saveGameToCoreData(game: Game) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        // Tạo một mới NSManagedObject (Entity là tên của entity trong Core Data)
        let gameEntity = NSEntityDescription.insertNewObject(forEntityName: "GameSave", into: context)
        // Thiết lập giá trị cho các thuộc tính
        gameEntity.setValue(game.gameId, forKey: "game_id")
        gameEntity.setValue("played", forKey: "status")
        gameEntity.setValue(game.sampleCover.thumbnailImageURL, forKey: "thumbnail_image")
        gameEntity.setValue(game.title, forKey: "title")
        
        
        // Lưu thay đổi vào Core Data
        do {
            try context.save()
            print("Game saved to Core Data")
        } catch  {
            print("Could not save game to Core Data.")
        }
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
                print(error.asAFError)
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
        cell.rowOfIndexPath = indexPath.row
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

