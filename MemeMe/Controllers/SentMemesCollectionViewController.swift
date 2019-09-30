//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Aurelijus Lape on 29/09/2019.
//  Copyright © 2019 Aurelijus Lape. All rights reserved.
//

import UIKit

private let reuseIdentifier = "SentMemeCollectionViewCell"

class SentMemesCollectionViewController: UICollectionViewController {

    var memes: [Meme]!
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.items?.forEach { $0.title = "" }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sent Memes"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                                                            action: #selector(createMeme))
        
        let space: CGFloat = 3.0
        let width = (view.frame.size.width - (2 * space)) / 3.0
        let height = (view.frame.size.height - (2 * space)) / 3.0

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumInteritemSpacing = space
        layout.minimumLineSpacing = space
        collectionView.collectionViewLayout = layout
    }

    //MARK: Collection view navigation methods
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: MemeDetailViewController.indifier)
            as! MemeDetailViewController
        vc.meme = memes[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Collection view data source methods
    
    //collectionViewedit
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let meme = memes[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! SentMemesCollectionViewCell
        cell.memeImageView.image = meme.memedImage
        cell.memeLabel.text = "\(meme.topText) \(meme.bottomText)"
        return cell
    }
    
    //MARK: Action methods
    
    @objc func createMeme() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "EditMemeViewController")
            as! EditMemeViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}
