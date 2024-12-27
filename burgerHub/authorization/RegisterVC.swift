//
//  RegisterVC.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 13.08.24.
//

import UIKit
import SwiftUI

class RegisterVC: UIViewController{
    
    
    
    private let safeArea = UIView.customView()
    private let logo = UIImageView.customUIImage(name: "logo", width: 34, height: 24)
    private let header1 = UILabel.customLabel()
    private let header2 = UILabel.customLabel()
    private let headerStack = UIStackView.customStackView()
    
    private let email = UILabel.customLabel()
    private let emailInput = CustomTextField(fieldType: .email)
    private let password = UILabel.customLabel()
    private let passwordInput = CustomTextField(fieldType: .password)
    private let rePassword = UILabel.customLabel()
    private let rePasswordInput = CustomTextField(fieldType: .password)
    
    private let emailStack = UIStackView.customStackView()
    private let passwordStack = UIStackView.customStackView()
    private let rePasswordStack = UIStackView.customStackView()
    private let detailStack = UIStackView.customStackView()
    private let createButton = UIButton.customButton(width: 335, height: 51, radius: 20)
    private let loginNavigate = UIButton.customButton(width: 335, height: 51, radius: 20)
  
    
    var itemModel =  RegisterVM()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .tertiarySystemGroupedBackground
        addSafeArea()
        addLogo()
        addHeader()
        addDetailsStack()
        addButtons()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    func addSafeArea(){
        view.addSubview(safeArea)
        NSLayoutConstraint.activate([
            safeArea.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            safeArea.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            safeArea.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            safeArea.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func addLogo(){
        safeArea.addSubview(logo)
        logo.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        logo.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 8).isActive = true
    }
    
    func addHeader(){
        safeArea.addSubview(headerStack)
        headerStack.spacing = 20
        NSLayoutConstraint.activate([
            headerStack.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 49),
            headerStack.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            headerStack.widthAnchor.constraint(equalToConstant: 287)
        ])
        
        header1.text = "Create an account"
        header1.font = .boldSystemFont(ofSize: 24)
    
        header2.font = UIFont(name: "FiraGO-Regular", size: 14)
        header2.text = "Welcome friend, enter your details so lets get started in ordering food."
        header2.numberOfLines = 2
        
        
        
        headerStack.addArrangedSubview(header1)
        headerStack.addArrangedSubview(header2)
    }
    
    func addDetailsStack(){
        safeArea.addSubview(detailStack)
        detailStack.spacing = 20
        NSLayoutConstraint.activate([
            detailStack.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 30),
            detailStack.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            detailStack.widthAnchor.constraint(equalToConstant: 334)])
        emailStack.spacing = 10
        passwordStack.spacing = 10
        rePasswordStack.spacing = 10
        
        
        detailStack.addArrangedSubview(emailStack)
        detailStack.addArrangedSubview(passwordStack)
        detailStack.addArrangedSubview(rePasswordStack)
        addSubstack()
    }
    
    func addSubstack(){
        emailStack.addArrangedSubview(email)
        emailStack.addArrangedSubview(emailInput)
        passwordStack.addArrangedSubview(password)
        passwordStack.addArrangedSubview(passwordInput)
        rePasswordStack.addArrangedSubview(rePassword)
        rePasswordStack.addArrangedSubview(rePasswordInput)
      
        email.text = "Email Address"
        email.font = UIFont(name: "FiraGO-Regular", size: 14)
        password.text = "Password"
        password.font = UIFont(name: "FiraGO-Regular", size: 14)
        rePassword.text = "Confirm password"
        rePassword.font = UIFont(name: "FiraGO-Regular", size: 14)
   
        emailInput.layer.cornerRadius = 15
        passwordInput.layer.cornerRadius = 15
        rePasswordInput.layer.cornerRadius = 15
        emailInput.font = UIFont(name: "FiraGO-Regular", size: 16)
        passwordInput.placeholder = "Enter password"
        passwordInput.font = UIFont(name: "FiraGO-Regular", size: 16)
        rePasswordInput.placeholder = "Confirm password"
        rePasswordInput.font = UIFont(name: "FiraGO-Regular", size: 16)
        
        NSLayoutConstraint.activate([
            email.leftAnchor.constraint(equalTo: detailStack.leftAnchor, constant: 23),
            emailInput.heightAnchor.constraint(equalToConstant: 50),
            emailInput.leftAnchor.constraint(equalTo: detailStack.leftAnchor),
            password.leftAnchor.constraint(equalTo: detailStack.leftAnchor, constant: 23),
            passwordInput.heightAnchor.constraint(equalToConstant: 50),
            passwordInput.leftAnchor.constraint(equalTo: detailStack.leftAnchor),
            rePassword.leftAnchor.constraint(equalTo: detailStack.leftAnchor, constant: 23),
            rePasswordInput.heightAnchor.constraint(equalToConstant: 50),
            rePasswordInput.leftAnchor.constraint(equalTo: detailStack.leftAnchor)
        ])
    }
    
   
    
    func addButtons(){
        safeArea.addSubview(createButton)
        safeArea.addSubview(loginNavigate)
        
        createButton.backgroundColor = .buttonC
        createButton.addAction(UIAction(handler: { _ in
            self.navigateToMain()}), for: .touchUpInside)
        
        createButton.setTitle("create an account", for: .normal)
        createButton.titleLabel?.font =  UIFont(name: "FiraGO-Regular", size: 16)
        loginNavigate.setTitleColor(.login, for: .normal)
        loginNavigate.setTitle("Login to my account", for: .normal)
        loginNavigate.titleLabel?.font = .boldSystemFont(ofSize: 16)
        loginNavigate.addAction(UIAction(title: "", handler:{ _ in
            self.goToLogin()}), for: .touchUpInside)
       
        createButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        createButton.topAnchor.constraint(equalTo: detailStack.bottomAnchor, constant: 90).isActive = true
        loginNavigate.topAnchor.constraint(equalTo: createButton.bottomAnchor, constant: 20).isActive = true
        loginNavigate.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
    }
    
    
    func goToLogin(){
        navigationController?.popViewController(animated: true)
    }
    
    func navigateToMain(){
        
        lazy var container = (UIApplication.shared.delegate as! AppDelegate).modelContainer
        
        
        guard  let rePasswords = rePasswordInput.text else { return sendAlert(message: "please fill fields", title: "error")}
        
        
        if !ValidateInfo.isValidEmail(for: emailInput.text ?? "") {
            sendAlert(message: "invalid mail", title: "Error")
            return
        }
        
        if !ValidateInfo.isPasswordValid(for: passwordInput.text ?? "") {
            sendAlert(message: "invalid password", title: "Error")
            return
        }
        
        let isSuccess = itemModel.registerUser(user: emailInput.text ?? "", password: passwordInput.text ?? "", rePassword: rePasswords)
        
        
        let swiftUIView = TabViews().modelContainer(container)

        let hostingController = UIHostingController(rootView: swiftUIView)

        
        if isSuccess {
            navigationController?.pushViewController(hostingController, animated: true)
            sendAlert(message: "welcome from burgerHub", title: "success")
            
        } else {
            sendAlert(message: "Registation Error", title: "Error")
        }
    }
    
}




#Preview{
    RegisterVC()
}
