//
//  ImageVC.swift
//  FirstsGitUsersList
//
//  Created by Mr. Bear on 14.04.2020.
//  Copyright © 2020 Mr. Bear. All rights reserved.
//

import UIKit

class ImageVC: UIViewController{
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        imageView.contentMode = .redraw

        showImage()
    }
    
    
    func showImage() {
        
        guard let url = URL(string: "https://picsum.photos/200/300") else {return}
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageView.image = image
                    self.activityIndicator.stopAnimating()
                }
            }
        }.resume()
        
    }
    
}
