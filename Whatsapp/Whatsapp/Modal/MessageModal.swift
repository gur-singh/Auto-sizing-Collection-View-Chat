//
//  MessageModal.swift
//  Whatsapp
//
//  Created by PrabSharan on 27/01/23.
//

import UIKit

struct Message : Codable {
    var temp_id : String?
    var created_at:String?
    var id : Int?
    var message : String?
    var media : Int?
    var user: User?
    var time : String?
    var actualImage:UIImage?
    var isHeightCalculated:Bool?
    var calculatedSize:CGSize?

    init(_  msg:String?,_ tempID:String?,_ media:Int?,_ time:String?,_ user:User?,_ actualImage:UIImage? = nil) {
        self.message = msg
        self.temp_id = tempID
        self.media = media
        self.time = time
        self.user = user
        self.actualImage = actualImage
    }

    enum CodingKeys: String, CodingKey {
        case temp_id = "temp_id"
        case created_at = "created_at"
        case id = "id"
        case message = "message"
        case media = "media"
        case user = "user"
        case time = "time"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        temp_id = try values.decodeIfPresent(String.self, forKey: .temp_id)
        id = try values.decodeIfPresent(Int.self, forKey: .id)

        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        media = try values.decodeIfPresent(Int.self, forKey: .media)
        user = try values.decodeIfPresent(User.self, forKey: .user)

        time = try values.decodeIfPresent(String.self, forKey: .time)
    }

}
class User: Codable {
    let name:String?
    let id:Int?
    init(_ name:String,_ id:Int) {
        self.name = name
        self.id = id
    }
}
