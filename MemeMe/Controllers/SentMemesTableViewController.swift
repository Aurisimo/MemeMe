//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Aurelijus Lape on 28/09/2019.
//  Copyright © 2019 Aurelijus Lape. All rights reserved.
//

import UIKit

private let reuseIdentifier = "SentMemeTableViewCell"

class SentMemesTableViewController: UITableViewController {

    var memes: [Meme]!
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.items?.forEach { $0.title = "" }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sent Memes"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                                                            action: #selector(createMeme))
    }

    //MARK: Table view navigation methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(
            withIdentifier: MemeDetailViewController.indifier) as! MemeDetailViewController
        vc.meme = memes[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Table view data source methods
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        
         if (editingStyle == UITableViewCell.EditingStyle.delete) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.memes.remove(at: indexPath.row)
            memes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
         }
     }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let meme = memes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)!
            as! SentMemeTableViewCell
        cell.memeImageView?.image = meme.memedImage
        cell.memeLabel?.text = "\(meme.topText) \(meme.bottomText)"
        return cell
    }

    //MARK: Action methods
    
    @objc func createMeme() {
        let vc = storyboard?.instantiateViewController(withIdentifier: EditMemeViewController.identifier)
            as! EditMemeViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}
