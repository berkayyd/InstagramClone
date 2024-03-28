//
//  FeedViewController.swift
//  InstagramClone
//
//  Created by Berkay Demir on 27.03.2024.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.userEmailLabel.text = "example@gmail.com"
        cell.userImageView.image = UIImage(named: "selectPhoto.png")
        cell.commentLabel.text = "comment"
        cell.likeLabel.text = "0"
        
        return cell
    }
    

    
}
