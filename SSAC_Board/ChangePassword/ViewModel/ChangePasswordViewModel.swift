//
//  ChangePasswordViewModel.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2022/01/06.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

class ChangePasswordViewModel: CommonViewModel {
    var disposeBag: DisposeBag =  DisposeBag()
    
    struct Input {
        let currentPassword: ControlProperty<String?>
        let passwordToChange: ControlProperty<String?>
        let checkPasswordToChange: ControlProperty<String?>
        let tap: ControlEvent<Void>
    }
    
    struct Output {
        let validCurrentPasswordStatus: Observable<Bool>
        let validPasswordToChange: Observable<Bool>
        let validCheckPasswordToChange: Observable<Bool>
        let sceneTransition: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let resultCurrentPassword = input.currentPassword
            .orEmpty
            .map { $0.count >= 4 }
            .share(replay: 1, scope: .whileConnected)
        
        let resultPasswordToChange = input.passwordToChange
            .orEmpty
            .map { $0.count >= 4 }
            .share(replay: 1, scope: .whileConnected)
        
        let resultCheckPasswordToChange = Observable.combineLatest(input.passwordToChange.orEmpty, input.checkPasswordToChange.orEmpty) { a, b -> Bool in
            return a == b
        }
        .share(replay: 1, scope: .whileConnected)
        
        return Output(validCurrentPasswordStatus: resultCurrentPassword, validPasswordToChange: resultPasswordToChange, validCheckPasswordToChange: resultCheckPasswordToChange, sceneTransition: input.tap)
    }
    
    
    func requestChangeUserPassword(currentPassword: String, newPassword: String, checkPassword: String, completion: @escaping (APIError?) -> ()) {
        APIService.changePassword(currentPassword: currentPassword, newPassword: newPassword, checkPassword: checkPassword) { _, error in
            completion(error)
        }
    }
}
