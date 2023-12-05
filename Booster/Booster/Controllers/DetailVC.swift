//
//  DetailVC.swift
//  Booster
//
//  Created by Fy Spoti on 29/11/2023.
//

import UIKit

class DetailVC: UIViewController {
    
    
    @IBOutlet weak var iconImage: UIImageView!
    var gameID: Int?
    var game: Game?
    
    @IBOutlet weak var background: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let game = game {
            fetchImageFromLinkToApplyBlur(imageLink: game.sampleCover.imageURL)
            fetchIconImage(imageLink: game.sampleCover.thumbnailImageURL)
        }
        
    }
    
    func getGameByID(gameID: Int) {
        MobyGamesService.share.fetchGameById(gameId: gameID) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let game):
                    // Handle the retrieved game
                    self.game = game
                    print("Fetched Game Done")
                    
                    
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
    
}
