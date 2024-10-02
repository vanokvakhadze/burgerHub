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
        let vc = LoginVC()
        self.navigationController?.pushViewController(vc, animated: true)
      
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
