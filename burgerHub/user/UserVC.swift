//
//  UserVC.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 16.08.24.
//

import UIKit

class UserVC: UIViewController {
    
    private let user = UILabel.customLabel()
    private let userTitle = CustomTextField(fieldType: .none)
    let safeArea = UIView.customView()
    var profileImage = UIImageView.customUIImages(width: 140, height: 140)
    let editImage = UIImageView.customUIImages(width: 16, height: 16)
    let imageViews = UIView.customView()
    let editView = UIView.customView()
    let logOut  = UIButton.customButton(width: 100, height: 50, radius: 20)
    let editButton = UIButton.customButton(width: 70, height: 30, radius: 15)
    let imagePicker = UIImagePickerController()
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
        logOutConfigure()
        profileImageConfiguration()
        addEditButton()
        userConfigure()
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
        safeArea.addSubview(userTitle)
        userTitle.text = authService().getUser(service: "IOS dev")
        user.text = "mail"
        userTitle.isEnabled = false
        
        
        NSLayoutConstraint.activate([
            user.topAnchor.constraint(equalTo: imageViews.bottomAnchor, constant: 30),
            user.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: -120),
            userTitle.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            userTitle.topAnchor.constraint(equalTo: user.bottomAnchor, constant: 15),
            userTitle.widthAnchor.constraint(equalToConstant: 260),
            userTitle.heightAnchor.constraint(equalToConstant: 40)
        ])
        
    }
    
    private func profileImageConfiguration(){
        safeArea.addSubview(imageViews)
        imageViews.backgroundColor = .clear
        imageViews.addSubview(profileImage)
        editImage.image = UIImage(systemName: "camera.fill")
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 70
        
        if let profileImg = viewModel.fetchImageFromFileManager() {
            profileImage.image = profileImg
        } else {
            profileImage.image = UIImage(systemName: "person")
            profileImage.tintColor = .gray
        }
        
        NSLayoutConstraint.activate([
        imageViews.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
        imageViews.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor, constant: -140),
        imageViews.widthAnchor.constraint(equalToConstant: 150),
        imageViews.heightAnchor.constraint(equalToConstant: 150),
        profileImage.centerXAnchor.constraint(equalTo: imageViews.centerXAnchor),
        profileImage.centerYAnchor.constraint(equalTo: imageViews.centerYAnchor)
        
        ])
        editImageConfiguration()
    }
    
    private func editImageConfiguration(){
        imageViews.addSubview(editView)
        editView.addSubview(editImage)
        editView.backgroundColor = .tertiarySystemBackground
        editView.clipsToBounds = true
        editView.layer.cornerRadius = 8
        editView.isHidden = true
        editImage.isHidden = true
        editImage.tintColor = .gray
        
 
        let tapped = UITapGestureRecognizer(target: self, action: #selector(didTapPhoto))
        editView.isUserInteractionEnabled = true
        editView.addGestureRecognizer(tapped)
        
        
        NSLayoutConstraint.activate([
            editView.centerXAnchor.constraint(equalTo: imageViews.trailingAnchor, constant: -23),
            editView.centerYAnchor.constraint(equalTo: imageViews.centerYAnchor, constant: 42),
            editView.widthAnchor.constraint(equalToConstant: 25),
            editView.heightAnchor.constraint(equalToConstant: 25),
            editImage.centerXAnchor.constraint(equalTo: editView.centerXAnchor),
            editImage.centerYAnchor.constraint(equalTo: editView.centerYAnchor),
            editImage.widthAnchor.constraint(equalToConstant: 22),
            editImage.heightAnchor.constraint(equalToConstant: 22)])
    }
    
    @objc func didTapPhoto() {
        if viewModel.editClicked  == true {
            self.imagePicker.delegate = self
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .photoLibrary
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                self.present(self.imagePicker, animated: true)
            }
        }
    }
    
    private func logOutConfigure(){
        safeArea.addSubview(logOut)
        logOut.setTitle("Delete ", for: .normal)
        logOut.titleLabel?.font =  UIFont(name: "FiraGO-Regular", size: 14)
        logOut.backgroundColor = .systemRed
        
        logOut.addAction(UIAction(handler: { _ in
            self.navigateToLogin()
        }), for: .touchUpInside)
        logOut.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        logOut.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -100).isActive = true
    }
    
    
    private func addEditButton(){
        safeArea.addSubview(editButton)
        editButton.setTitle("Edit", for: .normal)
        editButton.backgroundColor = .blue
        editButton.addAction(UIAction(handler: {[weak self] _ in
            self?.tapEdit()
        }), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            editButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 15),
            editButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10)])
    }
    
    func tapEdit()  {
        guard let user = userTitle.text else {return }
        guard  let currentAccount = authService().getUser(service: "IOS dev") else {return}
        if viewModel.editClicked  {
            do {
                try viewModel.updateUserName(newAccount: user, service: "IOS dev", currentAccount: currentAccount)
                userTitle.isEnabled = false
                editButton.setTitle("Edit", for: .normal)
                editView.isHidden = true
                editImage.isHidden = true
            } catch {
                sendAlert(message: "Error",  title: error.localizedDescription)
            }
        } else {
            if viewModel.isSignedUpWithGoogle(email: currentAccount) {
                userTitle.isEnabled = false
                editButton.setTitle("Done", for: .normal)
                editView.isHidden = false
                editImage.isHidden = false
                sendAlert(message: "Error", title: "you can't change Email ")
            }else{
                userTitle.isEnabled = true
                userTitle.backgroundColor = .lightGray
                editButton.setTitle("Done", for: .normal)
                editView.isHidden = false
                editImage.isHidden = false
            }
            }
         
        viewModel.toggleEdit()
        
    }
    
    func navigateToLogin(){
        let vc = LoginVC()
        do {
            try authService().deletePassword(service: "IOS dev", account: userTitle.text ?? "")
            self.navigationController?.present(vc, animated: true)
            self.modalPresentationStyle = .fullScreen
            sendAlert(message: "your account was deleted", title: "Success")
        } catch {
            sendAlert(message: "account couldn't delete", title: "Delete error")
        }
        
      
       
    }
    
   
    
}

extension UserVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            viewModel.saveImageToFileManager(image)
            profileImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}


#Preview {
    UserVC()
}
