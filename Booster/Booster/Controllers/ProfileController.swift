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
import PinterestSegment

protocol ProfileDataReloadDelegate: AnyObject {
    func reloadData()
}

class ProfileController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CollectionItemGameDelegate, ProfileDataReloadDelegate {
    func imageTapped(at rowOfIndexPath : IndexPath) {
        performSegue(withIdentifier: "profileToDetailVC", sender: rowOfIndexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileToDetailVC", let rowOfIndexPath = sender as? IndexPath {
            let destinationVC = segue.destination as! DetailVC
//            let gameID = (results[rowOfIndexPath.row].value(forKey: "game_id") as? Int)!
//            MobyGamesService.share.fetchGameById(gameId: gameID) {
//                result in
//                switch result {
//                case .success(let game):
//                    destinationVC.game = game
//                case .failure(let error):
//                    print(error)
//                }
//            }
            destinationVC.gameID = (results[rowOfIndexPath.row].value(forKey: "game_id") as? Int)!
            if let title = results[rowOfIndexPath.row].value(forKey: "status") as? String {
                destinationVC.status = title
                destinationVC.reloadDelegate = self
                
            }
        }
    }
    
    
    func reloadData() {
            fetchGamesFromCoreData()
            collectionView.reloadData()
        }
    
    
    func addButtonTapped(at rowOfIndexPath : IndexPath) {
        
        let menuViewController = PopMenuViewController(actions: [
            PopMenuDefaultAction(title: "Uncategorized", didSelect: { action in
                // action is a `PopMenuAction`, in this case it's a `PopMenuDefaultAction`
                self.dismiss(animated: false)
                self.updateGameInCoreData(at: rowOfIndexPath, withNewStatus: "Uncategorized")
                
                
            }),
            PopMenuDefaultAction(title: "Currently playing", didSelect: { action in
                // action is a `PopMenuAction`, in this case it's a `PopMenuDefaultAction`
                self.dismiss(animated: false)
                self.updateGameInCoreData(at: rowOfIndexPath, withNewStatus: "Currently playing")
                
            }),
            PopMenuDefaultAction(title: "Played", didSelect: { action in
                // action is a `PopMenuAction`, in this case it's a `PopMenuDefaultAction`
                self.dismiss(animated: false)
                self.updateGameInCoreData(at: rowOfIndexPath, withNewStatus: "Played")
                
            }),
            PopMenuDefaultAction(title: "To Play", didSelect: { action in
                // action is a `PopMenuAction`, in this case it's a `PopMenuDefaultAction`
                self.dismiss(animated: false)
                self.updateGameInCoreData(at: rowOfIndexPath, withNewStatus: "To Play")
                
            }),
            PopMenuDefaultAction(title: "Delete", didSelect: { action in
                // action is a `PopMenuAction`, in this case it's a `PopMenuDefaultAction`
                self.dismiss(animated: false)
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
            
            
            
            collectionView.reloadData()
            
        } catch {
            print("Error updating game: \(error)")
            
            collectionView.reloadData()
        }
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
            
            collectionView.reloadData()
            
        } catch {
            print("Error deleting game: \(error)")
            // Hiển thị thông báo lỗi
            
        }
    }
    

    var results = [NSManagedObject]()
    var games = [GameSave]()
    

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    
    
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
            cell.buttonAdd.text = status
        }
        let tapGesture = UITapGestureRecognizer(target: cell, action: #selector(CollectionItemGame.addButtonTapped))
        cell.buttonAdd.isUserInteractionEnabled = true
        cell.buttonAdd.addGestureRecognizer(tapGesture)
        
        if let title = results[indexPath.row].value(forKey: "title") as? String {
            cell.nameGame.text = title
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target: cell, action: #selector(CollectionItemGame.imageTapped))

        cell.imageGame.isUserInteractionEnabled = true
        cell.imageGame.addGestureRecognizer(tapGestureRecognizer)
        
        cell.rowOfIndexPath = indexPath
        cell.delegate = self
        
        return cell
    }
    
    func setUISegment() -> UIView {
        let w = view.frame.width
        let s = PinterestSegment(frame: CGRect(x: 20, y: 88, width: w - 40, height: 40), titles: ["All", "Uncategorized", "Currently playing", "Played", "To Play"])
        s.style.titleFont = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(rawValue: 5))
        s.valueChange = {
            index in
            
            if index == 0 {
                self.fetchGamesFromCoreData()
            } else {
                self.fetchGamesWithStatus(status: s.titles[index])
            }
            
        }
        return s
    }
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let w = view.frame.width
//        let s = PinterestSegment(frame: CGRect(x: 20, y: 88, width: w - 40, height: 40), titles: ["All", "Uncategorized", "Currently playing", "Played", "To Play"])
//        s.style.titleFont = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(rawValue: 5))
        view.addSubview(setUISegment())

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CollectionItemGame", bundle: nil), forCellWithReuseIdentifier: "idCell")
        
        
        setupCollectionViewLayout(isGrid: false)
        fetchGamesFromCoreData()
        NotificationCenter.default.addObserver(self, selector: #selector(fetchGamesFromCoreData), name: NSNotification.Name("reloadProfileData"), object: nil)
        
        updateTabBarItemBadge()
//        if let tabBarController = self.tabBarController {
//            if let tabBarItem = tabBarController.tabBar.items?[1] {
//                tabBarItem.badgeValue = "\(results.count)"
//            }
//        }

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
            singleItemLayout.minimumInteritemSpacing = 1
            singleItemLayout.minimumLineSpacing = 1
            singleItemLayout.itemSize = CGSize(width: 300, height: 520)
            layout = singleItemLayout
        }
        
        collectionView.collectionViewLayout = layout
    }

        func updateTabBarItemBadge() {
            if let tabBarController = self.tabBarController {
                if let tabBarItem = tabBarController.tabBar.items?[1] {
                    tabBarItem.badgeValue = "\(results.count)"
                }
            }
        }
    
    @objc func fetchGamesFromCoreData() {
        results.removeAll()
        games.removeAll()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GameSave")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            results = try context.fetch(fetchRequest) as! [NSManagedObject]
            
            for result in results {
                       if let game = result as? GameSave {
                           games.append(game)
                       }
                   }
            
            if let tabBarController = self.tabBarController {
                if let tabBarItem = tabBarController.tabBar.items?[1] {
                    tabBarItem.badgeValue = "\(results.count)"
                }
            }
            collectionView.reloadData()
        } catch {
            print("Errol")
        }
    }
    
    func fetchGamesWithStatus(status: String) {
        results.removeAll()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GameSave")
        
        fetchRequest.predicate = NSPredicate(format: "status == %@", status)
        
        do {
            results = try context.fetch(fetchRequest) as! [NSManagedObject]
            
            if let tabBarController = self.tabBarController {
                if let tabBarItem = tabBarController.tabBar.items?[1] {
                    tabBarItem.badgeValue = "\(results.count)"
                }
            }
            collectionView.reloadData()
        } catch {
            print("Errol")
        }
    }
    
    
    
    
}
