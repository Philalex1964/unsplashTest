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
        self.author = json["name"].stringValue
        self.selectedPhoto = selectedPhoto ?? false
    }
}

/*{
    "total": 124115,
    "total_pages": 4138,
    "results": [
    {
    "id": "f0heeiu-Ec0",
    "created_at": "2018-11-01T13:30:51-04:00",
    "updated_at": "2019-07-28T01:04:52-04:00",
    "width": 2592,
    "height": 3872,
    "color": "#714B02",
    "description": "Taking close up macro photographs of flowers have always been a passion of mine. This radiant dahlia has the perfect array of light pink petals.",
    "alt_description": "pink dahlia in bloom",
    "urls": {
    "raw": "https://images.unsplash.com/photo-1541093113199-a2e9d84e903f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjg0NzE2fQ",
    "full": "https://images.unsplash.com/photo-1541093113199-a2e9d84e903f?ixlib=rb-1.2.1&q=85&fm=jpg&crop=entropy&cs=srgb&ixid=eyJhcHBfaWQiOjg0NzE2fQ",
    "regular": "https://images.unsplash.com/photo-1541093113199-a2e9d84e903f?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjg0NzE2fQ",
    "small": "https://images.unsplash.com/photo-1541093113199-a2e9d84e903f?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max&ixid=eyJhcHBfaWQiOjg0NzE2fQ",
    "thumb": "https://images.unsplash.com/photo-1541093113199-a2e9d84e903f?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&ixid=eyJhcHBfaWQiOjg0NzE2fQ"
    },
    "links": {
    "self": "https://api.unsplash.com/photos/f0heeiu-Ec0",
    "html": "https://unsplash.com/photos/f0heeiu-Ec0",
    "download": "https://unsplash.com/photos/f0heeiu-Ec0/download",
    "download_location": "https://api.unsplash.com/photos/f0heeiu-Ec0/download"
    },
    "categories": [],
    "likes": 370,
    "liked_by_user": false,
    "current_user_collections": [],
    "user": {
    "id": "cNoApWkGbQk",
    "updated_at": "2019-07-20T07:26:04-04:00",
    "username": "joyful_janine",
    "name": "Janine Joles",
    "first_name": "Janine",
    "last_name": "Joles",
    "twitter_username": "janinejoles",
    "portfolio_url": "https://www.instagram.com/janinejoles/",
    "bio": "It's a JOY to share my photos with you for free. And an even bigger JOY when you show appreciation ♥︎ https://paypal.me/janinejoles ♥︎ Please enjoy and thank you for your support!",
    "location": "Italy",
    "links": {
    "self": "https://api.unsplash.com/users/joyful_janine",
    "html": "https://unsplash.com/@joyful_janine",
    "photos": "https://api.unsplash.com/users/joyful_janine/photos",
    "likes": "https://api.unsplash.com/users/joyful_janine/likes",
    "portfolio": "https://api.unsplash.com/users/joyful_janine/portfolio",
    "following": "https://api.unsplash.com/users/joyful_janine/following",
    "followers": "https://api.unsplash.com/users/joyful_janine/followers"
    },
    "profile_image": {
    "small": "https://images.unsplash.com/profile-1531333378029-1e4b75388b2f?ixlib=rb-1.2.1&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=32&w=32",
    "medium": "https://images.unsplash.com/profile-1531333378029-1e4b75388b2f?ixlib=rb-1.2.1&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=64&w=64",
    "large": "https://images.unsplash.com/profile-1531333378029-1e4b75388b2f?ixlib=rb-1.2.1&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=128&w=128"
    },
    "instagram_username": "janinejoles",
    "total_collections": 8,
    "total_likes": 14,
    "total_photos": 35,
    "accepted_tos": true
    },
    "tags": [
    {
    "title": "blossom"
    },
    {
    "title": "dahlia"
    },
    {
    "title": "plant"
    },
    {
    "title": "petal"
    },
    {
    "title": "asteraceae"
    },
    {
    "title": "aster"
    },
    {
    "title": "daisy"
    },
    {
    "title": "daisies"
    },
    {
    "title": "nail"
    },
    {
    "title": "spiral"
    },
    {
    "title": "pollen"
    },
    {
    "title": "animal"
    },
    {
    "title": "invertebrate"
    },
    {
    "title": "insect"
    },
    {
    "title": "grasshopper"
    },
    {
    "title": "grasshoper"
    },
    {
    "title": "marble"
    },
    {
    "title": "gladiolus"
    },
    {
    "title": "coil"
    },
    {
    "title": "lily"
    }
    ]
    },
*/
