//
//  PopVC.swift
//  PixelCity
//
//  Created by Kafkas Baranseli on 16/05/2019.
//  Copyright © 2019 Baranseli. All rights reserved.
//

import UIKit

class PopVC: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var popImageView: UIImageView!
    
    // 070 initialise and pass image data to PopVC
    var passedImage = UIImage()
    
    func initData(forImage image: UIImage) {
        self.passedImage = image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popImageView.image = passedImage
        // 075 call doubleTap func
        addDoubleTap()
    
    }
    // 072 UITapGestureRecognizer
    func addDoubleTap() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(PopVC.screenWasDoubleTapped))
        // 074 doubleTap config and add gestureRecognizer
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delegate = self
        view.addGestureRecognizer(doubleTap)
        
        
    }
    
    // 073 for #selector
    @objc func screenWasDoubleTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    
    

    
}
