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
    let avatarUrl: String?
    let htmlUrl: String?
    let reposUrl: String?
    let name: String?
    let company: String?
    let location: String?
    let publicRepos: Int?
    let publicGists: Int?
    let followers: Int?
    let createdAt: String?
}
