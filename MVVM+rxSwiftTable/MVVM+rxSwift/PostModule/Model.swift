//
//  Model.swift
//  MVVM+rxSwift
//
//  Created by Сергей Сырбу on 05.02.2024.
//

import Foundation

struct User: Codable {
    let userID, id: Int?
    var title, body: String?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}
