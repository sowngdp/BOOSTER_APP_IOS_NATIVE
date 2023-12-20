//
//  ViewController.swift
//  Booster
//
//  Created by Fy Spoti on 02/10/2023.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!{
        didSet {
            scrollView.delegate = self
        }
    }
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var viewSlide: Slides!
    
    
    var slides:[Slides] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(viewSlide)
    }

    @IBAction func nextToLoginView(_ sender: Any) {
    }
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
    
    func createSlides() -> [Slides] {

        let slide1:Slides = Bundle.main.loadNibNamed("Slides", owner: self, options: nil)?.first as! Slides
        slide1.imageView.image = UIImage(named: "item_preview1")
        slide1.labelTitle.text = "1 Duplicate Apps: Call History, Notes, and more"

        let slide2:Slides = Bundle.main.loadNibNamed("Slides", owner: self, options: nil)?.first as! Slides
        slide2.imageView.image = UIImage(named: "item_preview2")
        slide2.labelTitle.text = "2 Duplicate Apps: Call History, Notes, and more"

        
        let slide3:Slides = Bundle.main.loadNibNamed("Slides", owner: self, options: nil)?.first as! Slides
        slide3.imageView.image = UIImage(named: "item_preview3")
        slide3.labelTitle.text = "3 Duplicate Apps: Call History, Notes, and more"

        

        
        return [slide1, slide2, slide3]
    }
    
    
    func setupSlideScrollView(slides : [Slides]) {

        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(slides.count), height: scrollView.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: scrollView.frame.width * CGFloat(i), y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            scrollView.addSubview(slides[i])
        }
    }

    }

    


