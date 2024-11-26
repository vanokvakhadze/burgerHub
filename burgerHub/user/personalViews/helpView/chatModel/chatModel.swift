//
//  chatModel.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 21.11.24.
//

import Foundation

struct Chat: Identifiable {
    var id: String
    var sendID: String
    var receiveID: String
    var content: String
    var mediaURL: String?
    var type: MessageType
    var timestamp:  Date
}

enum MessageType {
    case text
    case photo
    case video
}
