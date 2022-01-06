//
//  ChangePasswordViewModel.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2022/01/06.
//

import Foundation

class ChangePasswordViewModel {
    var currentPassword: _Observable<String> = _Observable("")
    var newPassword: _Observable<String> = _Observable("")
    var checkPassword: _Observable<String> = _Observable("")
    
    func requestChangeUserPassword(completion: @escaping () -> ()) {
        APIService.changePassword(currentPassword: currentPassword.value, newPassword: newPassword.value, checkPassword: checkPassword.value) { userData, error in
            completion()
        }
    }
}
