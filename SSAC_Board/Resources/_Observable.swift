//
//  _Observable.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2022/03/03.
//

import Foundation

final class _Observable<T> {
    private var listner: ((T) -> Void)?
    
    var value: T {
        didSet {
            listner?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ listner: @escaping (T) -> Void) {
        listner(value)
        self.listner = listner
    }
}
