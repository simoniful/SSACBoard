//
//  PostViewModel.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2021/12/31.
//

import Foundation

class PostViewModel {
    var posts:[Post] = []
    
    func requestPosts(completion: @escaping () -> ()) {
        APIService.readPost { postData, error in
            guard let postData = postData else { return }
            self.posts = postData
            completion()
        }
    }
}

extension PostViewModel {
    var numberOfRowInSection: Int {
        return posts.count
    }
    
    func cellForRowAt(at indexPath: IndexPath) -> Post {
        return posts[indexPath.row]
    }
}
