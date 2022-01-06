//
//  DetailPostViewModel.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2022/01/03.
//

import Foundation

class DetailPostViewModel {
    var comments: Comment = []
    var commentText: Observable<String> = Observable("")
    
    func requestCommentData(_ postId: Int ,completion: @escaping () -> ()) {
        APIService.readComment(postId: postId) { commentData, error in
            guard let commentData = commentData else { return }
            self.comments = commentData
            completion()
        }
    }
    
    func requestCreateComment(_ postId: Int ,completion: @escaping () -> ()) {
        APIService.createComment(postId: postId, comment: commentText.value) { commentData, error in
            guard let commentData = commentData else { return }
            self.comments.append(commentData)
            completion()
        }
    }
    
    func requestDeletePost(_ postId: Int, completion: @escaping () -> ()) {
        APIService.deletePost(postId: postId) { postData, error in
            completion()
        }
    }
    
    func requestDeleteComment(_ commentId: Int, completion: @escaping () -> ()) {
        APIService.deleteCommet(commentId: commentId) { commentData, error in
            guard let commentData = commentData else { return }
            let fileredComments = self.comments.filter { element in
                element.id != commentData.id
            }
            self.comments = fileredComments
            completion()
        }
    }
}

extension DetailPostViewModel {
    var numberOfRowInSection: Int {
        return comments.count
    }
    
    func cellForRowAt(at indexPath: IndexPath) -> CommentElement {
        return comments[indexPath.row]
    }
}
