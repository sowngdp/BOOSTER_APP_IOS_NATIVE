//
//  SampleScreenshot.swift
//  Booster
//
//  Created by Fy Spoti on 07/11/2023.
//

import Foundation

// Screenshot model
struct Screenshot: Decodable {
    let caption: String
    let height: Int
    let imageURL: String
    let thumbnailImageURL: String
    let width: Int

    private enum CodingKeys: String, CodingKey {
        case caption
        case height
        case imageURL = "image"
        case thumbnailImageURL = "thumbnail_image"
        case width
    }
}
