//
//  UserViewModel.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 20.08.24.
//

import Foundation
import UIKit


protocol UserDelegate: AnyObject {
    func updateUserView()
}

class UserViewModel: ObservableObject {
    
    @Published var auth = authService()
    @Published var clicked = false
    @Published var editClicked = false 
   
    
    let manager = FileManager.default
    @Published var documentsDirectoryPath = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first
    
    weak var delegate: UserDelegate?
    
    func getUser(){
        delegate?.updateUserView()
    }
    
    func toggleEdit(){
        editClicked.toggle()
    }
    
    func isSignedUpWithGoogle(email: String) -> Bool {
        do {
            if let providerData = authService().get(service: "IOS dev", account: "\(email)_provider") {
                
                if let provider = String(data: providerData, encoding: .utf8) {
                    return provider == "google" 
                }
            }
       
        }
        return false
    }
    
    func update(password: Data, service: String ) throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject
        ]
        
        let attributes: [String: AnyObject] = [
            kSecValueData as String: password as AnyObject
        ]
        
        let status = SecItemUpdate(
            query as CFDictionary,
            attributes as CFDictionary
        )
        
        guard status != errSecItemNotFound else {
            throw KeyChainError.nosuchDataFound
        }
        
        guard status == errSecSuccess else {
            throw KeyChainError.KCErrorWithCode(Int(status))
        }
        
    }
    
    
    
    func updateUserName(newAccount: String, service: String, currentAccount: String) throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: currentAccount as AnyObject,
        ]
        
        let attributes: [String: AnyObject] = [
            kSecAttrAccount as String: newAccount as AnyObject
        ]
        
        let status = SecItemUpdate(
            query as CFDictionary,
            attributes as CFDictionary
        )
        
        guard status != errSecItemNotFound else {
            throw KeyChainError.nosuchDataFound
        }
        
        guard status == errSecSuccess else {
            throw KeyChainError.KCErrorWithCode(Int(status))
        }
    }
    
    func deleteAccount(service: String, account: String) -> Bool {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: service as AnyObject,
                kSecAttrAccount as String: account as AnyObject
            ]
          
            let status = SecItemDelete(query as CFDictionary)
            
            if status == errSecSuccess {
                print("Successfully deleted account from Keychain.")
                return true
            } else {
                print("Failed to delete account from Keychain: \(status)")
                return false
            }
        }
    
    
    func saveImageToFileManager(_ image: UIImage) {
        guard var documentsDirectoryPath = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else {
                   print("Failed to get documents directory path.")
                   return
               }
    
               documentsDirectoryPath.appendPathComponent("userImage")
               DispatchQueue.global().async {
                   if let imageData = image.pngData() {
                       do {
                           let success = self.manager.createFile(
                               atPath: documentsDirectoryPath.path,
                               contents: imageData,
                               attributes: nil
                           )
                           
                           if success {
                               print("Image saved successfully at \(documentsDirectoryPath.path)")
                           } else {
                               print("Failed to save image.")
                           }
                       }
                   } else {
                       print("Failed to convert image to PNG data.")
                   }
               }
    }
    
    func fetchImageFromFileManager() -> UIImage? {
              guard var documentsDirectoryPath = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else {
                  print("Failed to get documents directory path.")
                  return nil
              }
              
              documentsDirectoryPath.appendPathComponent("userImage")
              
              if manager.fileExists(atPath: documentsDirectoryPath.path) {
                  do {
                      let imageData = try Data(contentsOf: documentsDirectoryPath)
                      
                      if let image = UIImage(data: imageData) {
                          print("Image fetched successfully from \(documentsDirectoryPath.path)")
                          return image
                      } else {
                          print("Failed to convert data to UIImage.")
                          return nil
                      }
                  } catch {
                      print("Error fetching image: \(error.localizedDescription)")
                      return nil
                  }
              } else {
                  print("Image file not found at \(documentsDirectoryPath.path)")
                  return nil
              }
          }

    
    
}
