//
//  CreateViewModel.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2022/01/03.
//

import Foundation

class CreateViewModel {
    var text: _Observable<String> = _Observable("")

    func requestCreatePost(completion: @escaping (Post?) -> ()) {
        APIService.createPost(text: text.value) { postData, error in
            guard let postData = postData else { return }
            completion(postData)
        }
    }
}
