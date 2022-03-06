//
//  UpdateViewModel.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2022/01/05.
//


import Foundation
import RxSwift
import RxCocoa

class UpdateViewModel {
    var text = BehaviorRelay(value: "")

    func requestUpdatePost(_ postId: Int, completion: @escaping (Post?) -> ()) {
        APIService.updatePost(text: text.value, postId: postId) { postData, error in
            guard let postData = postData else { return }
            completion(postData)
        }
    }
    
    func requestUpdateComment(commentId: Int ,postId: Int, completion: @escaping (CommentElement?) -> ()) {
        APIService.updateComment(commentId: commentId, postId: postId, comment: text.value) { commentData, error in
            guard let commentData = commentData else { return }
            completion(commentData)
        }
    }
}
