//
//  PostViewModel.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2021/12/31.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

class PostViewModel {
    var disposeBag: DisposeBag =  DisposeBag()
    
    var postsObservable: PublishRelay<[Post]> = PublishRelay()
    var errorObservable: PublishSubject<APIError> = PublishSubject()
    var postCount = PublishSubject<Int>()
       
    var posts:[Post] = []
    
    func requestReadPost(start: Int, limit: Int, refresh: Bool = false) {
        LoadingIndicator.shared.showIndicator()
    
        APIService.readPost(start: start, limit: limit) { [weak self] (data, error) in
            guard let self = self else { return }
            guard error == nil else {
                LoadingIndicator.shared.hideIndicator()
                self.errorObservable.onNext(error!)
                return
            }
            guard let data = data else { return }
            refresh == true ? (self.posts = data) : (self.posts += data)
            self.postsObservable.accept(self.posts)
            LoadingIndicator.shared.hideIndicator()
        }
    }
    
    func requestReadPost() {
        LoadingIndicator.shared.showIndicator()
            
        APIService.readPost(start: 0, limit: 20) { [weak self] (data, error) in
            guard let self = self else { return }
            guard error == nil else {
                LoadingIndicator.shared.hideIndicator()
                self.errorObservable.onNext(error!)
                return
            }
            guard let data = data else { return }
            self.posts = data
            self.postsObservable.accept(self.posts)
            LoadingIndicator.shared.hideIndicator()
        }
    }
    
    func requestCountPost(errorHandler: @escaping (APIError?) -> Void) {
        APIService.countPost { [weak self](count, error) in
            guard error == nil else {
                errorHandler(error!)
                return
            }
            guard let count = count else {
                return
            }
            self?.postCount.onNext(count)
            errorHandler(nil)
        }
    }
    
    deinit {
        disposeBag = DisposeBag()
    }
}
