//
//  DreamResponse.swift
//  DreamTracker
//
//  Created by nakama on 08/12/18.
//  Copyright © 2018 Tokopedia. All rights reserved.
//

import Foundation

struct Todo: Decodable {
    let id: Int
    let title: String?
    let is_checked: Bool
}

struct Dream: Decodable {
    let id: Int
    let user_id: Int
    let title: String?
    let description: String?
    let image_uri: String?
    let todo: [Todo]?
}

struct DreamResponse: Decodable {
    let success: Bool
    let error: String?
    let data: [Dream]?
}
