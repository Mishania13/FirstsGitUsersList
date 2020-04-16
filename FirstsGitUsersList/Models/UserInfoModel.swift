//
//  UserInfoModel.swift
//  FirstsGitUsersList
//
//  Created by Mr. Bear on 15.04.2020.
//  Copyright © 2020 Mr. Bear. All rights reserved.
//

import Foundation

struct UserInfoModel: Decodable {
    
    let login: String?
    let avatar_url: String?
    let html_url: String?
    let repos_url: String?
    let name: String?
    let company: String?
    let location: String?
    let public_repos: Int?
    let public_gists: Int?
    let followers: Int?
    let created_at: String?
}
