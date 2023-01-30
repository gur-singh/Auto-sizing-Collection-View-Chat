//
//  ViewController.swift
//  Whatsapp
//
//  Created by PrabSharan on 25/01/23.
//

import UIKit
import SocketIO
import Starscream

class SocketChatManager {

    // MARK: - Properties
    private let manager = SocketManager(socketURL: URL(string: "ws://localhost:3000")!, config: [.log(true), .compress])
    private var socket: SocketIOClient? = nil
    var delegate: EventsDelegate?
    private let user: User?

    init(_ user:User?) {
        self.user = user
        setupSocket()
    }

    func stop() {
        socket?.removeAllHandlers()
    }

    // MARK: - Socket Setup
    func setupSocket() {
        self.socket = manager.defaultSocket
    }
    func connect() {
        socket?.on(clientEvent: .connect) {[weak self] data, ack in
            self?.register(user: self?.user?.name ?? "")
            self?.setupSocketEvents()
            self?.delegate?.didReceiveEvent(.Connected)
            print("Connected")
        }
        socket?.connect()
    }
    //All events
    func typingEvent() {
        socket?.emit(Events.Typing.title, user?.name ?? "")
    }
    func userOfflineEvent() {
        socket?.emit(Events.UserOffline.title, user?.name ?? "")
        socket?.disconnect()
    }

    func setupSocketEvents() {
        socket?.on("login") { (data, ack) in
            guard let dataInfo = data.first else { return }
                print("Now this chat has \(dataInfo) users.")
        }
        socket?.on("user joined") {[weak self] (data, ack) in
            guard let dataInfo = data.first as? NSDictionary else { return }
            if let joined = dataInfo["userJoined"] as? String {
                self?.delegate?.didReceiveEvent(.UserJoined(joined))
            }
                print("Now this chat has \(dataInfo) users.")
        }
        socket?.on("user left") { (data, ack) in
            guard let dataInfo = data.first else { return }
                print("Now this chat has \(dataInfo) users.")
            }
        socket?.on("new message") { [weak self](data, ack) in
            guard let dataInfo = data.first as? NSDictionary else { return }
                print("Message from '\(dataInfo)")
           if let msg = dataInfo["message"] as? Data {
               let message = try? JSONDecoder().decode(Message.self, from: msg)
                self?.delegate?.didReceiveEvent(.ReceiveMessage(message))
            }

        }

        socket?.on("typing") {[weak self] (data, ack) in
            guard let dataInfo = data.first else { return }
            self?.delegate?.didReceiveEvent(.ReceiveMessage(dataInfo))
            }

        socket?.on("stop typing") { (data, ack) in
            guard let dataInfo = data.first else { return }
                print("User \(dataInfo) stopped typing...")
            }
    }

    // MARK: - Socket Emits
    func register(user: String) {
        socket?.emit("add user", user)
    }

    func send(message: Data) {
        socket?.emit("new message", message)
    }

}
