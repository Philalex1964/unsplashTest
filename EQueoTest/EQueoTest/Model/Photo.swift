//
//  Photo.swift
//  EQueoTest
//
//  Created by Alexander Filippov on 8/3/19.
//  Copyright © 2019 Alexander Filippov. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class Photo: Codable {
    let photoID: String
    let photoDescription: String
    let photoURL: String
    let author: String
    var selectedPhoto: Bool?
    
    init(_ json: JSON) {
        self.photoID = json["id"].stringValue
        self.photoDescription = json["alt_description"].stringValue
        self.photoURL = json["urls"]["thumb"].stringValue
        self.author = json["user"]["name"].stringValue
        self.selectedPhoto = selectedPhoto ?? false
    }
}

