//
//  CustomTextField.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 14.08.24.
//

import Foundation
import UIKit

class CustomTextField: UITextField {
    
    var clicked = false 
    
    enum CustomTextFieldType {
        case email
        case password
        case none
      
    }
    
    private let authFieldType: CustomTextFieldType
    
    init(fieldType: CustomTextFieldType) {
        self.authFieldType = fieldType
        super.init(frame: .zero)
        setUpTextField()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpTextField(){
        self.backgroundColor = .systemBackground
        self.layer.borderColor = .init(red: 2, green: 2, blue: 2, alpha: 1)

        self.layer.cornerRadius = 15
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.returnKeyType = .done
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        
        self.leftViewMode = .always
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 23, height: self.frame.size.height))
        
        switch authFieldType {
        case .email:
            self.placeholder = "Enter email"
            self.minimumFontSize = 14
            self.keyboardType = .emailAddress
            self.textContentType = .emailAddress
            
        case .password:
            self.placeholder = ""
            self.textContentType = .oneTimeCode
            self.isSecureTextEntry =  true
            setPlaceholder()
            
        case .none:
            self.placeholder = ""
        }
    }
    
    func setPlaceholder() {
   
        let img = UIImage(systemName: clicked ? "eye.slash" : "eye")
        let imageView = UIImageView(image: img)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: -10, y: -8, width: 24, height: 24)
        imageView.isUserInteractionEnabled = true
        imageView.tintColor = .black
        
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: self.frame.size.height))
        containerView.addSubview(imageView)
        
        self.rightView = containerView
        self.rightViewMode = .always
        let tapped = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        containerView.addGestureRecognizer(tapped)
    }
    
   
    @objc func imageTapped(){
        clicked.toggle()
        self.isSecureTextEntry.toggle()
      
        if let eyeImage = self.rightView?.subviews.first as? UIImageView {
            eyeImage.image =  UIImage(systemName: clicked ?  "eye.slash" : "eye")
               }
        
    }
     
}
