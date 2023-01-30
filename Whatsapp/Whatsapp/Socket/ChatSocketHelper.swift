//
//  SocketHelper.swift
//  Whatsapp
//
//  Created by PrabSharan on 29/01/23.
//

import Foundation

struct SizeForBubble {
    static let TopLabelSize:CGFloat = 0
    static let TopPadding:CGFloat = 10
    static let BottomPadding:CGFloat = 12
    static let SizeForTimeLabel:CGFloat  = 10
    static let LeftInsetForCell:CGFloat = 10
    static let RightInsetForCell:CGFloat = 55
    static let SizeForImg:CGSize = CGSize(width: 230, height: 270)
}
enum Media: Int {
    case Text = 0
    case Image
    case Video

}
enum Events {
    case Connected
    case ReceiveMessage(Any?)
    case Disconnected
    case Typing
    case UserJoined(String)
    case UserOffline
    case Login
    var title: String {
        switch self {
        case .Connected:
            return ""
        case .ReceiveMessage(_):
            return "new message"
        case .Disconnected:
            return "disconnected"
        case .Typing:
            return "typing"
        case .UserJoined(_):
            return "user joined"
        case .UserOffline:
            return "user left"
        case .Login:
            return "login"
        }
    }
}


extension Events: Equatable {
    static func == (lhs: Events, rhs: Events) -> Bool {
        switch (lhs,rhs) {
        case (.Connected,.Connected):
            return true
        case (.Disconnected,.Disconnected):
            return true
        default: return false
        }
    }
}
protocol EventsDelegate {
    func didReceiveEvent(_ events:Events)
}
