//
//  DetailVC.swift
//  Booster
//
//  Created by Fy Spoti on 29/11/2023.
//

import UIKit
import WebKit

class DetailVC: UIViewController, WKNavigationDelegate  {
    
    
    @IBOutlet weak var iconImage: UIImageView!
    var gameID: Int?
    var game: Game?
    
    
    @IBOutlet weak var descriptionLable: WKWebView!
    @IBOutlet weak var background: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionLable.navigationDelegate = self
        if let gameID = gameID {
            getGameByID(gameID: gameID)
        }
        if let game = game {
            fetchImageFromLinkToApplyBlur(imageLink: game.sampleCover.imageURL)
            fetchIconImage(imageLink: game.sampleCover.thumbnailImageURL)
            descriptionLable.loadHTMLString(game.description!, baseURL: nil)
        }
        
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
                    self.descriptionLable.loadHTMLString(game.description!, baseURL: nil)
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
