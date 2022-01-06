//
//  Observable.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2021/12/30.
//

import Foundation

class Observable<T> {
    private var listener: ((T) -> ())?
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping (T) -> ()) {
        closure(value)
        listener = closure
    }
}
