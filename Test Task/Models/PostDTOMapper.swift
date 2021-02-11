//
//  PostDTOMapper.swift
//  Test Task
//
//  Created by Gleb Ilchyshyn on 10.02.2021.
//  Copyright © 2021 Gleb Ilchyshyn. All rights reserved.
//

import Foundation

private let singletonInstance = PostDTOMapper()

class PostDTOMapper {
  static var sharedInstance: PostDTOMapper { return singletonInstance }
    
    static func map(_ dto: PostDTO, postId : String) -> Post {
        return Post(id: postId, type: dto.type, payload: dto.payload)
  }
}
