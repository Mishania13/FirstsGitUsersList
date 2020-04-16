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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
    }
    

}
