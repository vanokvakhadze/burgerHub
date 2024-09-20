//
//  LoginVC.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 16.08.24.
//

import Foundation
import GoogleSignIn
import UIKit

class LoginVC: UIViewController {
    
    private let safeArea = UIView.customView()
    private let logo = UIImageView.customUIImage(name: "logo", width: 34, height: 24)
    private let header1 = UILabel.customLabel()
    private let header2 = UILabel.customLabel()
    private let headerStack = UIStackView.customStackView()
    
    private let email = UILabel.customLabel()
    private let emailInput = CustomTextField(fieldType: .email)
    private let password = UILabel.customLabel()
    private let passwordInput = CustomTextField(fieldType: .password)
    
    private let emailStack = UIStackView.customStackView()
    private let passwordStack = UIStackView.customStackView()
    private let detailStack = UIStackView.customStackView()
    private let loginButton = UIButton.customButton(width: 335, height: 51, radius: 20)
    private let registerNav = UIButton.customButton(width: 335, height: 51, radius: 20)
    
    private let gooleView = UIView.customView()
    private let gooleImage = UIImageView.customUIImage(name: "google", width: 24, height: 24)
    private let googleText = UILabel.customLabel()
    
 
    var iteModel = LoginVM()
    var itemModel2 = RegisterVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .tertiarySystemGroupedBackground
        addSafeArea()
        addLogo()
        addHeader()
        addDetailsStack()
        addGoogleButton()
        addButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.navigationItem.hidesBackButton = true
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
        logo.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 28).isActive = true
    }
    
    func addHeader(){
        safeArea.addSubview(headerStack)
        headerStack.spacing = 20
        NSLayoutConstraint.activate([
            headerStack.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 49),
            headerStack.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            headerStack.widthAnchor.constraint(equalToConstant: 287)
        ])
        
        header1.text = "Login to your account"
        header1.font = .boldSystemFont(ofSize: 24)
    
        header2.font = UIFont(name: "FiraGO-Regular", size: 14)
        header2.text = "Good to see you again, enter your details below to continue ordering."
        header2.numberOfLines = 2
        
        
        
        headerStack.addArrangedSubview(header1)
        headerStack.addArrangedSubview(header2)
    }
    
    func addDetailsStack(){
        safeArea.addSubview(detailStack)
        detailStack.spacing = 20
        NSLayoutConstraint.activate([
            detailStack.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 50),
            detailStack.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            detailStack.widthAnchor.constraint(equalToConstant: 334)])
        emailStack.spacing = 10
        passwordStack.spacing = 10

        
        
        detailStack.addArrangedSubview(emailStack)
        detailStack.addArrangedSubview(passwordStack)

        addSubstack()
    }
    
    func addSubstack(){
        emailStack.addArrangedSubview(email)
        emailStack.addArrangedSubview(emailInput)
        passwordStack.addArrangedSubview(password)
        passwordStack.addArrangedSubview(passwordInput)
       
        email.text = "Email Address"
        email.font = UIFont(name: "FiraGO-Regular", size: 14)
        password.text = "Password"
        password.font = UIFont(name: "FiraGO-Regular", size: 14)
       
        emailInput.layer.cornerRadius = 15
        passwordInput.layer.cornerRadius = 15
        emailInput.font = UIFont(name: "FiraGO-Regular", size: 16)
        passwordInput.placeholder = "Enter password"
        passwordInput.font = UIFont(name: "FiraGO-Regular", size: 16)
        
        
        NSLayoutConstraint.activate([
            email.leftAnchor.constraint(equalTo: detailStack.leftAnchor, constant: 23),
            emailInput.heightAnchor.constraint(equalToConstant: 50),
            emailInput.leftAnchor.constraint(equalTo: detailStack.leftAnchor),
            password.leftAnchor.constraint(equalTo: detailStack.leftAnchor, constant: 23),
            passwordInput.heightAnchor.constraint(equalToConstant: 50),
            passwordInput.leftAnchor.constraint(equalTo: detailStack.leftAnchor)
        ])
    }
    
    func addGoogleButton(){
        safeArea.addSubview(gooleView)
        gooleView.clipsToBounds = true
        gooleView.backgroundColor = .systemBackground
        gooleView.layer.cornerRadius = 20
        
        gooleView.addSubview(gooleImage)
        gooleView.addSubview(googleText)
        
        googleText.font = UIFont(name: "FiraGO-Regular", size: 14)
        googleText.setUnderlinedText("Sing-in with Google")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(googleSignIn))
            gooleView.isUserInteractionEnabled = true
            gooleView.addGestureRecognizer(tap)
        NSLayoutConstraint.activate([
        gooleView.topAnchor.constraint(equalTo: detailStack.bottomAnchor, constant: 80),
        gooleView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
        gooleView.widthAnchor.constraint(equalToConstant: 204),
        gooleView.heightAnchor.constraint(equalToConstant: 50),
        gooleImage.centerYAnchor.constraint(equalTo: gooleView.centerYAnchor),
        gooleImage.leadingAnchor.constraint(equalTo: gooleView.leadingAnchor, constant: 24),
        googleText.centerYAnchor.constraint(equalTo: gooleView.centerYAnchor),
        googleText.leadingAnchor.constraint(equalTo: gooleImage.trailingAnchor, constant: 11)
        ])
        
    }
    
    @objc func googleSignIn(){
        _ = GIDConfiguration(clientID: "710353786699-31f6mnisijter89q9agg1ca74j3a0kjq.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { user, error in
            if let error = error {
                self.sendAlert(message: "Error with Google Sign-In:", title: "\(error.localizedDescription)")
                
            }
            
            guard let user = user else {return}
            let userMail = user.user.profile?.email ?? ""
            
            let success = self.itemModel2.SingUpWithSocial(value: userMail, key: "IOS dev")
            
            if success {
                self.navigationController?.pushViewController(UserVC(), animated: true)
            } else {
                self.sendAlert(message: "Authorization Error", title: "Error")
            }
           
        }
    }
    
    
    
    func addButtons(){
        safeArea.addSubview(loginButton)
        safeArea.addSubview(registerNav)
        
        loginButton.backgroundColor = .buttonC
        loginButton.addAction(UIAction(handler: { _ in
            self.loginToMain()}), for: .touchUpInside)
        
        loginButton.setTitle("login an account", for: .normal)
        loginButton.titleLabel?.font =  UIFont(name: "FiraGO-Regular", size: 16)
        registerNav.setTitleColor(.login, for: .normal)
        registerNav.setTitle("Register account", for: .normal)
        registerNav.titleLabel?.font = .boldSystemFont(ofSize: 16)
        registerNav.addAction(UIAction(title: "", handler: { _ in
            self.registration()}), for: .touchUpInside)
        
        
       
        loginButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: gooleView.bottomAnchor, constant: 20).isActive = true
        registerNav.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20).isActive = true
        registerNav.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
    }
    
    
    func registration(){
        navigationController?.pushViewController(RegisterVC(), animated: true)
    }
    
    func loginToMain() {
        guard let user = emailInput.text, !user.isEmpty else {return sendAlert(message: "please fill email field", title: "Error")}
        
        guard  let passwords = passwordInput.text, !passwords.isEmpty else {return sendAlert(message: "please fill password field", title: "Error")}
        
        let success = iteModel.Login(user: user, password: passwords)
        
        if success {
            navigationController?.pushViewController(UserVC(), animated: true)
        } else {
            sendAlert(message: "not matches email or password", title: "Error")
        }
    }
}


#Preview{
    LoginVC()
}
