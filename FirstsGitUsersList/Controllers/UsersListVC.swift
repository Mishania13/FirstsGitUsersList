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
                self.tableView.separatorStyle = .none
                
                DispatchQueue.main.async {
                    self.tableView.isHidden = false
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                }
                
            } catch let error {
                print("Decoder error: \(error.localizedDescription)")
            }
        }.resume()
        
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
        
        if let imageUrlCache = imageCach.object(forKey: imageUrl as NSString) as? URL {
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
    
    
    
// MARK: - Navigator
//
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
        
        let cell = self.tableView.cellForRow(at: indexPath) as? UserListCell
        self.selectedCellImage = cell?.userImage.image
        
        self.performSegue(withIdentifier: "UserProfileIdentifire", sender: profiles[indexPath.row].avatarUrl)
    }
  
}
