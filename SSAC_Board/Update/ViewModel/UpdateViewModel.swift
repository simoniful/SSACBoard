//
//  UpdateViewModel.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2022/01/05.
//

import Foundation
// 클로저 통한 수정 후 화면 전환시 페이지 반영
// 댓글 작성 후 텍스트 초기화 ""
class UpdateViewModel {
    var text: _Observable<String> = _Observable("")

    func requestUpdatePost(_ postId: Int, completion: @escaping (Post?) -> ()) {
        APIService.updatePost(text: text.value, postId: postId) { postData, error in
            guard let postData = postData else { return }
            completion(postData)
        }
    }
    
    func requestUpdateComment(commentId: Int ,postId: Int, completion: @escaping (CommentElement?) -> ()) {
        print(#function)
        APIService.updateComment(commentId: commentId, postId: postId, comment: text.value) { commentData, error in
            guard let commentData = commentData else { return }
            completion(commentData)
        }
    }
}
