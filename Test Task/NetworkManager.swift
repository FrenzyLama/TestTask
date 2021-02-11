//
//  NetworkManager.swift
//  Test Task
//
//  Created by Gleb Ilchyshyn on 09.02.2021.
//  Copyright © 2021 Gleb Ilchyshyn. All rights reserved.
//

import Foundation

let urlPostRequest = "http://demo7877231.mockable.io/api/v1/post/"
let notificationKey = "fetchPostInfo"

private let singletonInstance = NetworkManager()

class NetworkManager {
    static var sharedInstance: NetworkManager { return singletonInstance }
    
    var downloadedPost : Post?
    
    // MARK: Fetch id list
    
    func requestIdList(){
        let session = URLSession.shared
        let url = URL(string: "http://demo7877231.mockable.io/api/v1/hot")!
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            if error != nil {
                print(error)
                return
            }
            do {
                if let list = try JSONDecoder().decode([Int]?.self, from: data! ){
                    var stringArray = list.map { String($0) }
                    UserDefaults.standard.set(stringArray, forKey: "IdList")
                    print(stringArray)
                }
            } catch {
                print("Error during JSON serialization: \(error.localizedDescription)")
            }
            
        })
        task.resume()
    }
    
    // MARK: Request post
    
    func requestPost(post id: String) {
        let session = URLSession.shared
        let url:URL! = URL(string: "http://demo7877231.mockable.io/api/v1/post/\(id)")
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            if error != nil {
                print(error)
                return
            }
            do {
                if let postDTO = try JSONDecoder().decode(PostDTO?.self, from: data! ){
                    let post = PostDTOMapper.map(postDTO, postId: id)
                    self.downloadedPost = post
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationKey), object: nil)
                    print(post)
                }
            } catch {
                print("Error during JSON serialization: \(error.localizedDescription)")
            }
            
        })
        task.resume()
    }
}

