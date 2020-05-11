//
//  AuthTextField.swift
//  Arjun_Dureja_iOS_Developer_PreprChallenge
//
//  Created by Arjun Dureja on 2020-05-08.
//  Copyright © 2020 Arjun Dureja. All rights reserved.
//

import UIKit

class AuthTextField: UITextField {
    // Custom textfield styling to reuse
    let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextField()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    func setupTextField() {
        clipsToBounds = true
        layer.cornerRadius = 20
        layer.borderWidth = 0.5
        font = UIFont.boldSystemFont(ofSize: 16)
        
        let toolBar = UIToolbar()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spacer, doneButton], animated: false)
        toolBar.sizeToFit()
        inputAccessoryView = toolBar
    }
    
    @objc func doneTapped() {
        endEditing(true)
    }
    
    
    
    
    
    
    
}
