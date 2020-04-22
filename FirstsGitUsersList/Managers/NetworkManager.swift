//
//  NetworkManager.swift
//  FirstsGitUsersList
//
//  Created by Mr. Bear on 20.04.2020.
//  Copyright © 2020 Mr. Bear. All rights reserved.
//

import UIKit

class NetworkManager {
    
    static var imageCache = NSCache<NSString, UIImage>()
    
   static func downloadImage(urlString: String?, completion: @escaping (UIImage?) -> Void) {
        
    guard let _ = urlString else { return }
    
    guard let url = URL(string: urlString!) else {return}
    
    if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage)
        } else {
            let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 3)
            let dataTask = URLSession.shared.dataTask(with: request) {  data, response, error in
                
                guard error == nil,
                    data != nil,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200
                     else { return  }
                
                guard let image = UIImage(data: data!) else { return }
                self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                
                DispatchQueue.main.async {
                    completion(image)
                }
            }
            dataTask.resume()
        }
    }
    
    static func fetchData<T: Decodable>(url: String, jsonData: @escaping (_ profiles:T)->(), interfaceActions: @escaping ()->()) {
        
        
        guard let url = URL(string: url) else {return}

        URLSession.shared.dataTask(with: url) { (data, _, _) in
            
            guard let data = data else {return}
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let profilesList = try decoder.decode(T.self, from: data)
                
                jsonData(profilesList)
                
                DispatchQueue.main.async {
                    interfaceActions()
                }
                
            } catch let error {
                print("Decode ERROR: \(error)")
            }
        } .resume()
    }
}
