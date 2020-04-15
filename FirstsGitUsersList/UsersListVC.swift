//
//  UsersListVC.swift
//  FirstsGitUsersList
//
//  Created by Mr. Bear on 14.04.2020.
//  Copyright © 2020 Mr. Bear. All rights reserved.
//

import UIKit

class UsersListVC: UIViewController {
    
    private let imageCach = NSCache<NSString, AnyObject>()
    var profiles = [UserListModel]()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    func fetchData() {
        
        guard let url = URL(string: "https://api.github.com/users") else {return}
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            
            if let error = error {
                print("Fetch data error: \(error.localizedDescription)")
            }
            
            guard let data = data else {return}
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let profiles = try decoder.decode([UserListModel].self, from: data)
                self.profiles = profiles
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } catch let error {
                print("Decoder error: \(error.localizedDescription)")
            }
        }.resume()
        
    }
    
    
    func cellConfiguration(cell: UserListCell, for indexPath: IndexPath) {
        
        let profile = profiles[indexPath.row]
        
        cell.nameLabel.text = "Name: \(profile.login.capitalized)"
        cell.idLabel.text = "ID: \(profile.id)"
        
        cell.userImage.layer.cornerRadius = 8
        cell.userImage.clipsToBounds = true
        
        cell.activityIndicator.startAnimating()
        cell.activityIndicator.hidesWhenStopped = true
        
        guard let url = URL(string: profile.avatarUrl) else {return}
        
        if let imageUrlCache = imageCach.object(forKey: profile.avatarUrl as NSString) as? URL {
            if let data = try? Data(contentsOf: imageUrlCache) {
                cell.userImage.image = UIImage(data: data)
            }
        } else {
            
            let session = URLSession.shared
            session.dataTask(with: url) { (data, _, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.userImage.image = image
                        cell.activityIndicator.stopAnimating()
                    }
                }
            }.resume()
        }
    }
}

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

extension UsersListVC: UITableViewDelegate {
    
}
