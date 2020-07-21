//
//  UserInfo.swift
//  OnTheMap
//
//  Created by Renad nasser on 17/07/2020.
//  Copyright © 2020 Renad nasser. All rights reserved.
//

import Foundation

// MARK: - User
struct User: Codable {
    let account: Account
    let session: Session
}

// MARK: - Account
struct Account: Codable {
    let registered: Bool
    let key: String
}

// MARK: - Session
struct Session: Codable {
    let id, expiration: String
}

