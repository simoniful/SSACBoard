//
//  CreateViewModel.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2022/01/03.
//

import Foundation
import RxSwift
import RxCocoa

class CreateViewModel {
    var text = BehaviorRelay(value: "")
    
    func requestCreatePost(completion: @escaping (Post?) -> ()) {
        APIService.createPost(text: text.value) { postData, error in
            guard let postData = postData else { return }
            completion(postData)
        }
    }
}
