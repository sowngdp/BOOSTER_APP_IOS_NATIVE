//
//  PlatformModel.swift
//  Booster
//
//  Created by Fy Spoti on 07/11/2023.
//

import Foundation

struct Platform: Decodable {
    let firstReleaseDate: String
    let platformId: Int
    let platformName: String

    private enum CodingKeys: String, CodingKey {
        case firstReleaseDate = "first_release_date"
        case platformId = "platform_id"
        case platformName = "platform_name"
    }
}
