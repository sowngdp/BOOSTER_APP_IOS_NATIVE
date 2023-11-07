//
//  Genres.swift
//  Booster
//
//  Created by Fy Spoti on 07/11/2023.
//

import Foundation


struct Genre: Decodable {
    let genreCategory: String
    let genreCategoryId: Int
    let genreId: Int
    let genreName: String

    private enum CodingKeys: String, CodingKey {
        case genreCategory = "genre_category"
        case genreCategoryId = "genre_category_id"
        case genreId = "genre_id"
        case genreName = "genre_name"
    }
}

