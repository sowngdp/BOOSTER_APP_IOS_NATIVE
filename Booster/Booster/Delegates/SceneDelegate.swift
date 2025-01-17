//
//  SceneDelegate.swift
//  Booster
//
//  Created by Fy Spoti on 02/10/2023.
//

import UIKit
import FirebaseAuth
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var tabbarController : UITabBarController?
    var navWelcomeController : UINavigationController?
    
    
    
    func loadNavControllers() {
        // Load navHome
        if let navHome = self.tabbarController?.viewControllers?[0] as? UINavigationController {
            // Accessing the root view controller of navHome triggers its viewDidLoad
            let _ = navHome.viewDidLoad() // This will call the viewDidLoad of navHome
        }
        
        // Load navProfile
        if let navProfile = self.tabbarController?.viewControllers?[1] as? UINavigationController {
            // Accessing the root view controller of navProfile triggers its viewDidLoad
            let _ = navProfile.viewDidLoad()// This will call the viewDidLoad of navProfile
        }
    }
    
    
    func updateProfileBadgeValue() {
            guard let tabBarController = self.tabbarController,
                  let tabBarItem = tabBarController.tabBar.items?[1] else {
                return
            }

            // Fetch games from Core Data
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext

            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GameSave")
            fetchRequest.returnsObjectsAsFaults = false

            do {
                let results = try context.fetch(fetchRequest) as! [NSManagedObject]
                tabBarItem.badgeValue = "\(results.count)"
            } catch {
                print("Error fetching games: \(error)")
            }
        }
    
    
    func isLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        
        
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        // guard let _ = (scene as? UIWindowScene) else { return }
        if isLoggedIn() {
            setRootViewTabbar()
        } else {
            setRootViewWelcome()
        }
        
    }
    
    
    func initNavWelcome() {
        if let navWelcome = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "navWelcome") as? UINavigationController {
            self.navWelcomeController = navWelcome
        }
    }
    
    
    func initTabbar()  {
        if let tabbar = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabbarID") as? UITabBarController {
            
            
            let navHome = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "navHome") as? UINavigationController
            let navProfile = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "navProfile") as? UINavigationController
            let settingId = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "settingID") as? UINavigationController
            
            let homeVC = navHome!
            let profileVC = navProfile!
            let settingVC = settingId!
            
            tabbar.viewControllers = [homeVC, profileVC, settingVC]
            if let profile = tabbar.viewControllers?[2] as? ProfileController {
                profile.viewDidLoad()
            }
            
            self.tabbarController = tabbar
            
            loadNavControllers()
        }
    }
    
    func setRootViewWelcome()  {
        // get Welcome Controller from Storyboard
        //Window.rootview = welcomeVC
        if self.navWelcomeController != nil {
            self.window?.rootViewController = self.navWelcomeController
            
        } else {
            initNavWelcome()
            self.window?.rootViewController = self.navWelcomeController
            
        }
        
        
        
    }
    func setRootViewTabbar()  {
        if self.tabbarController != nil {
            self.window?.rootViewController = self.tabbarController
            loadNavControllers()
            updateProfileBadgeValue()
        } else {
            initTabbar()
            self.window?.rootViewController = self.tabbarController
            updateProfileBadgeValue()
            
        }
        //get tabbar from storyboard : id : tabbarID
        //set roootView window.rootview = tabbar
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
}
