//
//  ProfileTableViewController.swift
//  Booster
//
//  Created by Fy Spoti on 06/11/2023.
//

import UIKit
import CoreData
import Alamofire
import AlamofireImage

class ProfileController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    struct Games {
        var gameId: String
        var status: String
        var thumbnailImageURL: String
        var title: String

        init(gameId: String, status: String, thumbnailImageURL: String, title: String) {
            self.gameId = gameId
            self.status = status
            self.thumbnailImageURL = thumbnailImageURL
            self.title = title
        }
    }

    
    var results = [NSManagedObject]()
    var games: [Games] = []
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "idCell", for: indexPath) as! CollectionItemGame
        
        let imageUrl = games[indexPath.row].thumbnailImageURL
        
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
        cell.buttonAdd.titleLabel?.text = games[indexPath.row].status
        cell.nameGame.text = games[indexPath.row].title
        
        return cell
    }
    

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CollectionItemGame", bundle: nil), forCellWithReuseIdentifier: "idCell")
        
        fetchGamesFromCoreData()
        NotificationCenter.default.addObserver(self, selector: #selector(fetchGamesFromCoreData), name: NSNotification.Name("reloadProfileData"), object: nil)
    }

    @objc func fetchGamesFromCoreData() {
        games.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GameSave")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            results = try context.fetch(fetchRequest) as! [NSManagedObject]
            
            if results.count > 0 {
                
                for result in results  {
                    if let title = result.value(forKey: "title") as? String,
                                       let gameId = result.value(forKey: "game_id") as? Int,
                                       let thumbnailImageURL = result.value(forKey: "thumbnail_image") as? String,
                                       let status = result.value(forKey: "status") as? String {

                                        // Tạo đối tượng Game từ dữ liệu Core Data
                                        let game = Games(gameId: String(gameId), status: status, thumbnailImageURL: thumbnailImageURL, title: title)
                                        games.append(game)
                                    }
                }
                    
                collectionView.reloadData()
                if let tabBarController = self.tabBarController {
                    if let tabBarItem = tabBarController.tabBar.items?[1] {
                        tabBarItem.badgeValue = "\(games.count)"
                    }
                }
                
            }
                
            } catch {
                print("Errol")
            }
        }
    
    
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        if action == #selector(UIResponderStandardEditActions.delete) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let context = appDelegate.persistentContainer.viewContext
            
            results.remove(at: indexPath.row)
            games.remove(at: indexPath.row)
            context.delete(results[indexPath.row])
            
            
            self.collectionView.reloadData()
            
            do {
                
                try context.save()
                
            } catch {
                
                print("Errol")
                
            }
            
        }
    }
    
}
