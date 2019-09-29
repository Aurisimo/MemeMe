//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Aurelijus Lape on 29/09/2019.
//  Copyright © 2019 Aurelijus Lape. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    static let indifier = "MemeDetailViewController"
    
    @IBOutlet var imageView: UIImageView!
    
    var meme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Meme Detail"
        
        imageView.image = meme.memedImage
    }
}
