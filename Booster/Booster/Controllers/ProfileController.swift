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

class ProfileController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CollectionItemGameDelegate {
    func imageTapped(at rowOfIndexPath : IndexPath) {
        performSegue(withIdentifier: "profileToDetailVC", sender: rowOfIndexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileToDetailVC", let rowOfIndexPath = sender as? IndexPath {
            let destinationVC = segue.destination as! DetailVC
            destinationVC.gameID = results[rowOfIndexPath.row].value(forKey: "game_id") as? Int
            
            
        }
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
            cell.buttonAdd.titleLabel?.text = status
        }
        
        if let title = results[indexPath.row].value(forKey: "title") as? String {
            cell.nameGame.text = title
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target: cell, action: #selector(CollectionItemGame.imageTapped))
//        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
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
