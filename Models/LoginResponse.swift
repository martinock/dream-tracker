//
//  LoginResponse.swift
//  DreamTracker
//
//  Created by nakama on 05/12/18.
//  Copyright © 2018 Tokopedia. All rights reserved.
//

import Foundation

struct Token: Decodable {
    let token: String?
}

struct LoginData: Decodable {
    let data: Token?
    let error: String?
    let success: Bool
}
