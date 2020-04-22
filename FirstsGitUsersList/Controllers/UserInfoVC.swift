//
//  UserInfoVC.swift
//  FirstsGitUsersList
//
//  Created by Mr. Bear on 15.04.2020.
//  Copyright © 2020 Mr. Bear. All rights reserved.
//

import UIKit

class UserInfoVC: UIViewController {

    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var userLinkButton: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var frameView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var labels: [UILabel]!
    
    var profile: UserListModel!
    var profileInfo: UserInfoModel?
    var userPageUrl: String {
        profile.url!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.frameView.isHidden = true
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidesWhenStopped = true
        for lable in self.labels {lable.isHidden = true}
        
        NetworkManager.fetchData(url: userPageUrl, jsonData: { (profileInfo) in
            self.profileInfo = profileInfo
        }) {
            self.setupUI()
        }
    }
    
    // MARK:- Navigator
    
    @IBAction func openLink () {
        performSegue(withIdentifier: "ProfileLink", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
        if segue.identifier == "ProfileLink" {
           
            guard let webVC = segue.destination as? UserWebPageVC else {return}
            if let _ = self.profile.htmlUrl {
            webVC.userLinkUrl = self.profile.htmlUrl!
            }
        }
    }
// MARK: - Interface working
    
    func setupUI(){
    
        NetworkManager.downloadImage(urlString: profileInfo!.avatarUrl) { (image) in
            self.userImage.image = image
        }
        
        self.activityIndicator.stopAnimating()
        self.frameView.isHidden = false
        
        self.loginLabel.text = profile.login?.capitalized
        
        for lable in self.labels {lable.numberOfLines = 0}
        self.labels[0].text = "Name: \(self.profileInfo?.name ?? "no data")"
        self.labels[1].text = "Location: \(self.profileInfo?.location ?? "no data")"
        self.labels[2].text = "Followers: \(self.profileInfo?.followers ?? 0)"
        self.labels[3].text = "Number of public repositories: \(self.profileInfo?.publicRepos ?? 0)"
        self.labels[4].text = "Number of public git's: \(self.profileInfo?.publicGists ?? 0)"
        self.labels[5].text = "Company: \"\(self.profileInfo?.company ?? "no data")\""
        self.labels[6].text = "Created: \(self.dateFormatter(ourDate: self.profileInfo?.createdAt))"
        
        for lable in self.labels {lable.isHidden = false}


    }
}
// MARK: - Support functions

extension UserInfoVC {
    
    func dateFormatter(ourDate: String?) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat =  "yyyy-MM-dd'T'HH:mm:ssZ"
        
        guard let _ = ourDate else {return "no date"}
        let date = formatter.date(from: ourDate!)

        formatter.dateFormat = "d MMM yyyy"
        return (formatter.string(from: date!))
    }

}
