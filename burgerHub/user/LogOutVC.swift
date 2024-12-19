//
//  LogOutVC.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 30.09.24.
//

import UIKit

class LogOutVC: UIViewController {
    let button = UIButton.customButton(width: 100, height: 50, radius: 20)

    override func viewDidLoad() {
        super.viewDidLoad()
        addButton()
    }
    
    func addButton(){
        view.addSubview(button)
        button.setTitle("Log Out", for: .normal)
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        button.backgroundColor = .buttonC
        button.tintColor = .white
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.navigateButton()
        }), for: .touchUpInside)
    }
    
    
    func navigateButton(){
        let loginVC = LoginVC()
    
        let user = authService().getUser(service: "IOS dev") ?? ""
        
        do {
            try authService().deletePassword(service: "IOS dev", account: user)

            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let window = scene.windows.first {
                        window.rootViewController = UINavigationController(rootViewController: loginVC)
                        window.makeKeyAndVisible()
                    }
            
                    }
        catch {
           // sendAlert(message: "account couldn't delete", title: "Delete error")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
