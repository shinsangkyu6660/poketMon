//
//  PoketMonAPI.swift
//  Poketmon - project
//
//  Created by 신상규 on 7/15/24.
//

import Foundation

struct PoketMonAPI: Codable {
    let sprites: sprites
}

struct sprites: Codable {
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}
