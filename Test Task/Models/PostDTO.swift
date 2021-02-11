//
//  PostDTO.swift
//  Test Task
//
//  Created by Gleb Ilchyshyn on 10.02.2021.
//  Copyright © 2021 Gleb Ilchyshyn. All rights reserved.
//

import Foundation

struct IdList : Codable {
    var arrayOfId: [Int]
}

enum PostType: String, Codable {
    case text
    case webpage
}

struct Payload: Codable {
    let text: String?
    let url: URL?
}

struct PostDTO: Codable {
    let type: PostType
    let payload: Payload
}
