//
//  DetailVC.swift
//  Booster
//
//  Created by Fy Spoti on 29/11/2023.
//

import UIKit

class DetailVC: UIViewController {
     
    
    var gameID: Int?
    var game: Game?

    @IBOutlet weak var background: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        getGameByID(gameID: gameID!)
        // Do any additional setup after loading the view.
        
        
    }
    
    func getGameByID(gameID: Int) {
        MobyGamesService.share.fetchGameById(gameId: gameID) { result in
            switch result {
            case .success(let game):
                // Handle the retrieved game
                self.game = game
                print("Fetched Game Done")
                DispatchQueue.main.async {
                    self.fetchImageFromLink(imageLink: (game.sampleCover.imageURL))
                }
            case .failure(let error):
                // Handle the error
                print("Error fetching game: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchImageFromLink (imageLink: String) {
        MobyGamesService.share.fetchImage(from: imageLink) { result in
            switch result {
            case .success(let image):
                // Handle the retrieved image
                self.background.image = self.applyBlur(to: image)
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

}
