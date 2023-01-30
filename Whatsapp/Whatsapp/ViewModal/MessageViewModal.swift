//
//  MessageViewModal.swift
//  Whatsapp
//
//  Created by PrabSharan on 27/01/23.
//

import UIKit




class MessageViewModal {
    private let socketManager:SocketChatManager?
    var messages:[Message]?
    private let user: User?
    var isConnected: Bool = false
    private let serialQueue = DispatchQueue(label: "serialQueue")
    private var delegate: EventsDelegate?

    init(_ user:User,_ delegate: EventsDelegate) {
        self.socketManager = SocketChatManager(user)
        self.user = user
        self.delegate = delegate
        self.socketManager?.delegate = self
        self.socketManager?.connect()
    }
    func emitEvent(_ event:Events) {
        switch event {
        case .Typing:
            socketManager?.typingEvent()
        case .UserOffline:
            socketManager?.userOfflineEvent()
        default:break;
        }
    }
    func sendMessage(_ media:Media, data:Any) {
        switch media {
        case .Text:
            serialQueue.async {
                if let msg = data as? String {
                    //Random id
                    let time = "05:00"
                    let message = Message(msg, "abc\(Int.random(in: 1...1000))", media.rawValue,time,self.user)
                    self.addToMessage(message)
                    let data = try? JSONEncoder().encode(message)
                    self.socketManager?.send(message: data ?? Data())
                }
            }
        case .Image: break

        case .Video: break

        }
    }
    
    func addToMessage(_ message:Message?) {
        if let message = message {
            if messages == nil {
                messages = [message]
            } else {
                messages?.append(message)
            }
        }
        delegate?.didReceiveEvent(.ReceiveMessage(nil))
    }
}

extension MessageViewModal: EventsDelegate {
    func didReceiveEvent(_ events: Events) {
        switch events {
        case .Connected:
            isConnected = true
            delegate?.didReceiveEvent(.Connected)
        case .Disconnected:
            isConnected = false
            delegate?.didReceiveEvent(.Disconnected)
        case .ReceiveMessage(let any):
           // parseMessage(any)
            if let message = any as? Message {
                addToMessage(message)
            }
        default: delegate?.didReceiveEvent(events)

        }
    }
    func parseMessage(_ data:Any) {
        print(data)
    }

}
