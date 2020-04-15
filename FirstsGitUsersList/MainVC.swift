//
//  MainVC.swift
//  FirstsGitUsersList
//
//  Created by Mr. Bear on 14.04.2020.
//  Copyright © 2020 Mr. Bear. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    @IBOutlet weak var showImageButton: UIButton!
    @IBOutlet weak var showUsersButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        buttonsView(for: showImageButton)
        buttonsView(for: showUsersButton)
    }
    
    @IBAction func imageButtonTap() {
        performSegue(withIdentifier: "ImageIdentifire", sender: self)
    }
    
    @IBAction func usersButtonTap() {
        performSegue(withIdentifier: "UsersIdentifire", sender: self)
    }
    
    private func buttonsView (for button: UIButton) {
        button.layer.cornerRadius = 10
        button.backgroundColor = #colorLiteral(red: 0.4332708716, green: 0.8587750793, blue: 0.6069030166, alpha: 1)
        button.titleLabel?.numberOfLines = 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let profilecVC = segue.destination as? UsersListVC
        
        if segue.identifier == "UsersIdentifire" {

                profilecVC?.fetchData()
        }
    }
}

