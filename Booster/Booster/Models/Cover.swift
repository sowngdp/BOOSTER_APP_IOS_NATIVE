//
//  SampleCover.swift
//  Booster
//
//  Created by Fy Spoti on 07/11/2023.
//

import Foundation

// SampleCover model
struct Cover: Decodable {
    let height: Int
    let imageURL: String
    let platforms: [String]
    let thumbnailImageURL: String
    let width: Int

    private enum CodingKeys: String, CodingKey {
        case height
        case imageURL = "image"
        case platforms
        case thumbnailImageURL = "thumbnail_image"
        case width
    }
}
