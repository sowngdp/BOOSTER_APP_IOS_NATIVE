//
//  DetailVC.swift
//  Booster
//
//  Created by Fy Spoti on 29/11/2023.
//

import UIKit
import WebKit
import PopMenu
import TagListView

class DetailVC: UIViewController, WKNavigationDelegate  {
    
    
    @IBOutlet weak var iconImage: UIImageView!
    var gameID: Int?
    var status = "";
    var game: Game?
    
    var reloadDelegate: ProfileDataReloadDelegate?

    
    
    @IBOutlet weak var scroceRating: UILabel!
    
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var starRatingView: StarRatingView!
    @IBOutlet weak var screnShotImage5: UIImageView!
    @IBOutlet weak var screnShotImage4: UIImageView!
    @IBOutlet weak var screnShotImage3: UIImageView!
    @IBOutlet weak var screnShotImage2: UIImageView!
    @IBOutlet weak var screnShotImage1: UIImageView!
    @IBOutlet weak var buttonStatus: UILabel!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var descriptionLable: WKWebView!
    @IBOutlet weak var background: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionLable.navigationDelegate = self
        if let gameID = gameID {
            getGameByID(gameID: gameID)
            buttonStatus.text = status
            
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.changeButtonTapped))
            
            buttonStatus.isUserInteractionEnabled = true
            
            buttonStatus.addGestureRecognizer(tapGesture)
            

            
        }
        if let game = game {
            fetchImageFromLinkToApplyBlur(imageLink: game.sampleCover.imageURL)
            fetchIconImage(imageLink: game.sampleCover.thumbnailImageURL)
            descriptionLable.loadHTMLString(game.description!, baseURL: nil)
            buttonStatus.text = "+ Add"
            titleLable.text = game.title
            gameID = game.gameId
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.addButtonTapped(_:)))
            
            buttonStatus.isUserInteractionEnabled = true
            
            buttonStatus.addGestureRecognizer(tapGesture)
            
            let stackImage = [screnShotImage1, screnShotImage2, screnShotImage3, screnShotImage4, screnShotImage5]

            // Lặp qua mảng ảnh từ thuộc tính game.sampleScreenshots
            for (index, sampleScrenShot) in game.sampleScreenshots.enumerated() {
                // Kiểm tra index để đảm bảo không vượt quá kích thước của mảng stackImage
                if index < stackImage.count {
                    // Lấy UIImageView từ mảng stackImage
                    let imageView = stackImage[index]
                    
                    // Sử dụng hàm fetchImage để tải ảnh và xử lý kết quả
                    fetchImage(imageLink: sampleScrenShot.imageURL) { result in
                        switch result {
                        case .success(let image):
                            // Hiển thị ảnh trong UIImageView
                            imageView?.image = image
                        case .failure(let error):
                            // Xử lý lỗi nếu có
                            print("Error fetching image: \(error.localizedDescription)")
                        }
                    }
                }
            }

            self.starRatingView.rating = Float(Double(game.mobyScore!/2))
            self.scroceRating.text = "\(Double(game.mobyScore!/2))"

        }
        
    }
    
    @objc func addButtonTapped(_ sender: UITapGestureRecognizer) {
        guard let game = game else {
            return
        }

        let menuViewController = PopMenuViewController(actions: [
            PopMenuDefaultAction(title: "Uncategorized", didSelect: { action in
                self.dismiss(animated: false)
                CoredataController.share.saveGameToCoreData(game: game, status: "Uncategorized") { success in
                    if success {
                        DispatchQueue.main.async {
                            self.buttonStatus.text = "Uncategorized"
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.showErrorMessage("This game is already in your collection.")
                        }
                    }
                }
            }),
            PopMenuDefaultAction(title: "Currently playing", didSelect: { action in
                self.dismiss(animated: false)
                CoredataController.share.saveGameToCoreData(game: game, status: "Currently playing") { success in
                    if success {
                        DispatchQueue.main.async {
                            self.buttonStatus.text = "Currently playing"
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.showErrorMessage("This game is already in your collection.")
                        }
                    }
                }
            }),
            PopMenuDefaultAction(title: "Played", didSelect: { action in
                self.dismiss(animated: false)
                CoredataController.share.saveGameToCoreData(game: game, status: "Played") { success in
                    if success {
                        DispatchQueue.main.async {
                            self.buttonStatus.text = "Played"
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.showErrorMessage("This game is already in your collection.")
                        }
                    }
                }
            }),
            PopMenuDefaultAction(title: "To Play", didSelect: { action in
                self.dismiss(animated: false)
                CoredataController.share.saveGameToCoreData(game: game, status: "To Play") { success in
                    if success {
                        DispatchQueue.main.async {
                            self.buttonStatus.text = "To Play"
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.showErrorMessage("This game is already in your collection.")
                        }
                    }
                }
            })
        ])

        present(menuViewController, animated: true, completion: nil)
    }
    
    func showErrorMessage(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }

    
    @objc func changeButtonTapped(_ sender: UITapGestureRecognizer) {
        
        guard let gameID = gameID else {
                // Không có gameID, không thể thực hiện thao tác
                return
            }
        
        let menuViewController = PopMenuViewController(actions: [
            PopMenuDefaultAction(title: "Uncategorized", didSelect: { action in
                // action is a `PopMenuAction`, in this case it's a `PopMenuDefaultAction`
                self.dismiss(animated: false)
                //self.updateGameInCoreData(at: rowOfIndexPath, withNewStatus: "Uncategorized")
                CoredataController.share.updateGameToCoreDataByGameID(gameID: gameID, withNewStatus: "Uncategorized")
                self.buttonStatus.text = "Uncategorized"
                
            }),
            PopMenuDefaultAction(title: "Currently playing", didSelect: { action in
                // action is a `PopMenuAction`, in this case it's a `PopMenuDefaultAction`
                self.dismiss(animated: false)
                //self.updateGameInCoreData(at: rowOfIndexPath, withNewStatus: "Currently playing")
                CoredataController.share.updateGameToCoreDataByGameID(gameID: gameID, withNewStatus: "Currently playing")
                self.buttonStatus.text = "Currently playing"
                
            }),
            PopMenuDefaultAction(title: "Played", didSelect: { action in
                // action is a `PopMenuAction`, in this case it's a `PopMenuDefaultAction`
                self.dismiss(animated: false)
                //self.updateGameInCoreData(at: rowOfIndexPath, withNewStatus: "Played")
                CoredataController.share.updateGameToCoreDataByGameID(gameID: gameID, withNewStatus: "Played")
                self.buttonStatus.text = "Played"
                
            }),
            PopMenuDefaultAction(title: "To Play", didSelect: { action in
                // action is a `PopMenuAction`, in this case it's a `PopMenuDefaultAction`
                self.dismiss(animated: false)
                //self.updateGameInCoreData(at: rowOfIndexPath, withNewStatus: "To Play")
                CoredataController.share.updateGameToCoreDataByGameID(gameID: gameID, withNewStatus: "To Play")
                self.buttonStatus.text = "To Play"
                
            }),
            PopMenuDefaultAction(title: "Delete", didSelect: { action in
                // action is a `PopMenuAction`, in this case it's a `PopMenuDefaultAction`
                self.dismiss(animated: false)
                //self.deleteGameFromCoreData(at: rowOfIndexPath)
                CoredataController.share.deleteGameFromCoreData(gameID: gameID)
                //ProfileController().updateTabBarItemBadge()
                // Khi bạn muốn quay lại profileViewController từ DetailVC
                self.reloadDelegate?.reloadData()

                // Quay về màn hình trước đó (Profile Game)
                self.navigationController?.popViewController(animated: true)
                
            })
        ])
        
        
        
        present(menuViewController, animated: true, completion: nil)
        
        
    }
    // WKNavigationDelegate method called when WKWebView finishes loading
    @objc(webView:didFinishNavigation:) func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Set font size using JavaScript
        let fontSize = 25
        // Your desired font size
        let fontSizeScript = "document.getElementsByTagName('body')[0].style.fontSize = '\(fontSize)px';"

        // Execute JavaScript to set font size
        webView.evaluateJavaScript(fontSizeScript, completionHandler: nil)
    }
    
    func getGameByID(gameID: Int) {
        MobyGamesService.share.fetchGameById(gameId: gameID) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let game):
                    // Handle the retrieved game
                    self.game = game
                    self.fetchImageFromLinkToApplyBlur(imageLink: game.sampleCover.imageURL)
                    self.fetchIconImage(imageLink: game.sampleCover.thumbnailImageURL)
                    self.titleLable.text = game.title
                    self.descriptionLable.loadHTMLString(game.description!, baseURL: nil)
                    print("Fetched Game Done")
                    self.titleLable.text = game.title
                    let stackImage = [self.screnShotImage1, self.screnShotImage2, self.screnShotImage3, self.screnShotImage4, self.screnShotImage5]

                    // Lặp qua mảng ảnh từ thuộc tính game.sampleScreenshots
                    for (index, sampleScrenShot) in game.sampleScreenshots.enumerated() {
                        // Kiểm tra index để đảm bảo không vượt quá kích thước của mảng stackImage
                        if index < stackImage.count {
                            // Lấy UIImageView từ mảng stackImage
                            let imageView = stackImage[index]
                            
                            // Sử dụng hàm fetchImage để tải ảnh và xử lý kết quả
                            self.fetchImage(imageLink: sampleScrenShot.imageURL) { result in
                                switch result {
                                case .success(let image):
                                    // Hiển thị ảnh trong UIImageView
                                    imageView?.image = image
                                case .failure(let error):
                                    // Xử lý lỗi nếu có
                                    print("Error fetching image: \(error.localizedDescription)")
                                }
                            }
                        }
                    }
                    
                    
                case .failure(let error):
                    // Handle the error
                    print("Error fetching game: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func fetchImageFromLinkToApplyBlur (imageLink: String) {
        MobyGamesService.share.fetchImage(from: imageLink) { result in
            switch result {
            case .success(let image):
                // Handle the retrieved image
                
                  self.background.image = self.applyBlur(to: image)
//                self.background.image = image
                print("Fetched Image")
            case .failure(let error):
                // Handle the error
                print("Error fetching image: \(error.localizedDescription)")
            }
        }
    }
    
    func applyBlur(to image: UIImage) -> UIImage {
        let ciContext = CIContext(options: nil)
        let ciImage = CIImage(image: image)
        
        let blurFilter = CIFilter(name: "CIGaussianBlur")
        blurFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        blurFilter?.setValue(10, forKey: kCIInputRadiusKey) // Adjust the radius for the desired blur
        
        if let outputImage = blurFilter?.outputImage,
           let cgImage = ciContext.createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        
        return image
    }
    
    func fetchIconImage (imageLink: String) {
        MobyGamesService.share.fetchImage(from: imageLink) {
            result in
            switch result {
            case .success(let image):
                self.iconImage.image = image
                
            case .failure(let error):
                break
            }
        }
    }
    
    func fetchImage(imageLink: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        MobyGamesService.share.fetchImage(from: imageLink) { result in
            switch result {
            case .success(let image):
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    
    
    
    
    
}
