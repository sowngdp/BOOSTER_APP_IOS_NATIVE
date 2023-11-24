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
import PopMenu

class ProfileController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CollectionItemGameDelegate {
    func addButtonTapped(at rowOfIndexPath : IndexPath) {
        
        let menuViewController = PopMenuViewController(actions: [
            PopMenuDefaultAction(title: "Uncategorized", didSelect: { action in
                // action is a `PopMenuAction`, in this case it's a `PopMenuDefaultAction`
                self.updateGameInCoreData(at: rowOfIndexPath, withNewStatus: "Uncategorized")
                
            }),
            PopMenuDefaultAction(title: "Currently playing", didSelect: { action in
                // action is a `PopMenuAction`, in this case it's a `PopMenuDefaultAction`
                self.updateGameInCoreData(at: rowOfIndexPath, withNewStatus: "Currently playing")
                
            }),
            PopMenuDefaultAction(title: "Played", didSelect: { action in
                // action is a `PopMenuAction`, in this case it's a `PopMenuDefaultAction`
                self.updateGameInCoreData(at: rowOfIndexPath, withNewStatus: "Played")
                
            }),
            PopMenuDefaultAction(title: "To Play", didSelect: { action in
                // action is a `PopMenuAction`, in this case it's a `PopMenuDefaultAction`
                self.updateGameInCoreData(at: rowOfIndexPath, withNewStatus: "To Play")
                
            }),
            PopMenuDefaultAction(title: "Delete", didSelect: { action in
                // action is a `PopMenuAction`, in this case it's a `PopMenuDefaultAction`
                self.deleteGameFromCoreData(at: rowOfIndexPath)
                
            })
        ])
        
        
        present(menuViewController, animated: true, completion: nil)
        
        
    }
    
    func updateGameInCoreData(at indexPath: IndexPath, withNewStatus status: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        // Lấy đối tượng GameSave tại indexPath
        let gameToUpdate = results[indexPath.row] as! GameSave
        
        // Cập nhật trạng thái mới
        gameToUpdate.setValue(status, forKey: "status")
        
        do {
            // Lưu thay đổi vào Core Data
            try context.save()
            
            // Cập nhật dữ liệu trong mảng results
            results[indexPath.row].setValue(status, forKey: "status")
            
            // Cập nhật cell để hiển thị trạng thái mới
            collectionView.reloadItems(at: [indexPath])
            
            // Hiển thị thông báo thành công
            showSuccessMessage("Game updated successfully")
            
        } catch {
            print("Error updating game: \(error)")
            // Hiển thị thông báo lỗi
            showErrorMessage("Failed to update game. Please try again.")
        }
    }

    func showSuccessMessage(_ message: String) {
        let alertController = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    func showErrorMessage(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    
    func deleteGameFromCoreData(at indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        // Lấy đối tượng GameSave tại indexPath
        let gameToDelete = results[indexPath.row] as! GameSave
        
        do {
            // Xoá đối tượng khỏi Core Data
            context.delete(gameToDelete)
            
            // Lưu thay đổi
            try context.save()
            
            // Cập nhật dữ liệu trong mảng results
            results.remove(at: indexPath.row)
            if let tabBarController = self.tabBarController {
                if let tabBarItem = tabBarController.tabBar.items?[1] {
                    tabBarItem.badgeValue = "\(results.count)"
                }
            }

            // Hiển thị thông báo thành công
            showSuccessMessage("Game deleted successfully")
            collectionView.reloadData()
            
        } catch {
            print("Error deleting game: \(error)")
            // Hiển thị thông báo lỗi
            showErrorMessage("Failed to delete game. Please try again.")
        }
    }

    

    
//    func updateGameInCoreData(at indexPath: IndexPath, withNewStatus status: String) {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//
//        // Lấy đối tượng GameSave tại indexPath
//        let gameToUpdate = results[indexPath.row] as! GameSave
//
//        // Cập nhật trạng thái mới
//        gameToUpdate.setValue(status, forKey: "status")
//
//        do {
//            // Lưu thay đổi vào Core Data
//            try context.save()
//
//            // Cập nhật dữ liệu trong mảng games
//            //results[indexPath.row].status = status
//
//            // Reload cell để hiển thị trạng thái mới
//            collectionView.reloadData()
//
//
//        } catch {
//            print("Error updating game: \(error)")
//        }
//    }
    
    
    

    
    
    var results = [NSManagedObject]()
    //    var games: [Games] = []
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    //    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "idCell", for: indexPath) as! CollectionItemGame
    //
    //        guard let gameObject = results[indexPath.row] as? NSManagedObject else {
    //            // Handle the case where gameObject is not of the expected type
    //            return cell
    //        }
    //
    //        // Accessing properties using key-value coding
    //        if let thumbnailImageURL = gameObject.value(forKey: "thumbnail_image") as? String {
    //            AF.request(thumbnailImageURL).responseImage { response in
    //                switch response.result {
    //                case .success(let image):
    //                    // Set the downloaded image to the UIImageView
    //                    cell.imageGame.image = image
    //
    //                case .failure(let error):
    //                    print("Image download failed: \(error)")
    //                }
    //            }
    //        }
    //
    //        if let status = gameObject.value(forKey: "status") as? String {
    //            cell.buttonAdd.titleLabel?.text = status
    //        }
    //
    //        if let title = gameObject.value(forKey: "title") as? String {
    //            cell.nameGame.text = title
    //        }
    //
    //        cell.rowOfIndexPath = indexPath.row
    //        cell.delegate = self
    //
    //        return cell
    //    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "idCell", for: indexPath) as! CollectionItemGame
        
        if let thumbnailImageURL = results[indexPath.row].value(forKey: "thumbnail_image") as? String {
            AF.request(thumbnailImageURL).responseImage { response in
                switch response.result {
                case .success(let image):
                    // Set the downloaded image to the UIImageView
                    cell.imageGame.image = image
                    
                case .failure(let error):
                    print("Image download failed: \(error)")
                }
            }
        }
        
        if let status = results[indexPath.row].value(forKey: "status") as? String {
            cell.buttonAdd.titleLabel?.text = status
        }
        
        if let title = results[indexPath.row].value(forKey: "title") as? String {
            cell.nameGame.text = title
        }
        
        cell.rowOfIndexPath = indexPath
        cell.delegate = self
        
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
        if let tabBarController = self.tabBarController {
            if let tabBarItem = tabBarController.tabBar.items?[1] {
                tabBarItem.badgeValue = "\(results.count)"
            }
        }
    }
    
    @objc func fetchGamesFromCoreData() {
        results.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GameSave")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            results = try context.fetch(fetchRequest) as! [NSManagedObject]
            
            //            if results.count > 0 {
            //
            //                for result in results  {
            //                    if let title = result.value(forKey: "title") as? String,
            //                                       let gameId = result.value(forKey: "game_id") as? Int,
            //                                       let thumbnailImageURL = result.value(forKey: "thumbnail_image") as? String,
            //                                       let status = result.value(forKey: "status") as? String {
            //
            //                                        // Tạo đối tượng Game từ dữ liệu Core Data
            //                                        let game = Games(gameId: String(gameId), status: status, thumbnailImageURL: thumbnailImageURL, title: title)
            //                                        games.append(game)
            //                                    }
            //                }
            
            
            if let tabBarController = self.tabBarController {
                if let tabBarItem = tabBarController.tabBar.items?[1] {
                    tabBarItem.badgeValue = "\(results.count)"
                }
            }
            collectionView.reloadData()
            
            //            }
            
        } catch {
            print("Errol")
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        if action == #selector(UIResponderStandardEditActions.delete) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let context = appDelegate.persistentContainer.viewContext
            
            results.remove(at: indexPath.row)
            //games.remove(at: indexPath.row)
            results.remove(at: indexPath.row)
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
