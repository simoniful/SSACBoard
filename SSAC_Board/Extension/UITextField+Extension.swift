//
//  Extension + UITextField.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2021/12/30.
//
import UIKit

class InsetTextField: UITextField {
    private let commonInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
    private let clearButtonOffset: CGFloat = 5
    private let clearButtonLeftPadding: CGFloat = 5
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: commonInsets)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: commonInsets)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        let clearButtonWidth = clearButtonRect(forBounds: bounds).width
        let editingInsets = UIEdgeInsets(
            top: commonInsets.top,
            left: commonInsets.left,
            bottom: commonInsets.bottom,
            right: clearButtonWidth + clearButtonOffset + clearButtonLeftPadding
        )
        return bounds.inset(by: editingInsets)
    }

    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        var clearButtonRect = super.clearButtonRect(forBounds: bounds)
        clearButtonRect.origin.x -= clearButtonOffset
        return clearButtonRect
    }
}
