//
//  UserVC.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 16.08.24.
//

import UIKit

class UserVC: UIViewController {
    private let user = UILabel.customLabel()
    let safeArea = UIView.customView()
    let logOut  = UIButton.customButton(width: 100, height: 50, radius: 20)
    
    
    
    let viewModel: UserViewModel
    
    init() {
        viewModel = UserViewModel()
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .tertiarySystemGroupedBackground
        safeAreaConfig()
        userConfigure()
        logOutConfigure()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    
    private func safeAreaConfig(){
        view.addSubview(safeArea)
        let safeZone = view.safeAreaLayoutGuide
        
        
        NSLayoutConstraint.activate([
            safeArea.topAnchor.constraint(equalTo: safeZone.topAnchor),
            safeArea.leadingAnchor.constraint(equalTo: safeZone.leadingAnchor),
            safeArea.trailingAnchor.constraint(equalTo: safeZone.trailingAnchor),
            safeArea.bottomAnchor.constraint(equalTo: safeZone.bottomAnchor)])
    }
    
    private func userConfigure(){
        safeArea.addSubview(user)
        user.text = authService().getUser(service: "IOS dev")
    }
    
    private func logOutConfigure(){
        safeArea.addSubview(logOut)
        logOut.setTitle("Log Out", for: .normal)
        logOut.titleLabel?.font =  UIFont(name: "FiraGO-Regular", size: 14)
        logOut.backgroundColor = .buttonC
        
        logOut.addAction(UIAction(handler: { _ in
            self.navigateToLogin()
        }), for: .touchUpInside)
        logOut.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        logOut.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -100).isActive = true
    }
    
    func navigateToLogin(){
        let vc = LoginVC()
        if viewModel.logOut(service: "IOS dev", account: user.text!) {
            navigationController?.pushViewController(vc,animated: true)
            print("delete successfully")
        } else {
            sendAlert(message: "account couldn't delete", title: "Delete error")
        }
       
    }
    
   
    
}


#Preview {
    UserVC()
}
