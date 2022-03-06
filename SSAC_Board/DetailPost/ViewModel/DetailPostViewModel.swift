//
//  DetailPostViewModel.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2022/01/03.
//

import Foundation
import RxSwift
import RxCocoa

class DetailPostViewModel {
    var disposeBag: DisposeBag =  DisposeBag()
    
    var commentText = BehaviorRelay(value: "")
    
    var commentsObservable: PublishRelay<Comment> = PublishRelay()
    var errorObservable: PublishSubject<APIError> = PublishSubject()
    var comments: Comment = []

    func requestCommentData(_ postId: Int) {
        APIService.readComment(postId: postId) { commentData, error in
            guard let commentData = commentData else { return }
            self.comments = commentData
            self.commentsObservable.accept(self.comments)
        }
    }
    
    func requestCreateComment(_ postId: Int ,completion: @escaping () -> ()) {
        APIService.createComment(postId: postId, comment: commentText.value) { commentData, error in
            guard let commentData = commentData else { return }
            self.comments.append(commentData)
            self.commentsObservable.accept(self.comments)
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
            self.commentsObservable.accept(self.comments)
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
