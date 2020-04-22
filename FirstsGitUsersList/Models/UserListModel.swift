//
//  UserListModel.swift
//  FirstsGitUsersList
//
//  Created by Mr. Bear on 14.04.2020.
//  Copyright © 2020 Mr. Bear. All rights reserved.
//

import Foundation

struct UserListModel: Decodable {
    let login: String?
    let id: Int?
    let avatarUrl: String?
    let htmlUrl: String?
    let url: String?
}
