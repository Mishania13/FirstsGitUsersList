//
//  UsersListVC.swift
//  FirstsGitUsersList
//
//  Created by Mr. Bear on 14.04.2020.
//  Copyright © 2020 Mr. Bear. All rights reserved.
//

import UIKit

class UsersListVC: UIViewController {
    
    var profiles = [UserListModel]()
    var ourCell: UserListCell?
    var selectedCellImage: UIImage?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.isHidden = true
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
    }
    
    
    
    
    func cellConfiguration(cell: UserListCell, for indexPath: IndexPath) {
        
        let profile = profiles[indexPath.row]
        
        if let name = profile.login {
            cell.nameLabel.text = "Name: \(name.capitalized)"
        }
        if let id = profile.id {
            cell.idLabel.text = "ID: \(id)"
        }
        
        cell.userImage.layer.cornerRadius = 8
        cell.userImage.clipsToBounds = true
        
        cell.activityIndicator.startAnimating()
        cell.activityIndicator.hidesWhenStopped = true
        
        guard let imageUrl = profile.avatarUrl else {return}

        guard let url = URL(string: imageUrl) else {return}


        NetworkManager.downloadImage(url: url) { (image) in
            cell.userImage.image = image
            self.activityIndicator.isHidden = true
        }
    }

    
// MARK: - Navigator
    
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "UserProfileIdentifire",
        let userVC = segue.destination as? UserInfoVC,
        let profile = sender as? UserListModel {
        userVC.profile = profile
    }
}
}
// MARK: - Data Source

extension UsersListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! UserListCell
        cellConfiguration(cell: cell, for: indexPath)
        
        return cell
    }
}

//MARK: - Delegate
extension UsersListVC: UITableViewDelegate {
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            self.performSegue(withIdentifier: "UserProfileIdentifire", sender: profiles[indexPath.row])
        }
}
