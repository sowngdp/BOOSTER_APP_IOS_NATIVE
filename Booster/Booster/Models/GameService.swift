//
//  GameService.swift
//  Booster
//
//  Created by Fy Spoti on 07/11/2023.
//

import Foundation
import Alamofire

class MobyGamesService {
    private let apiKey = "moby_8BhL8vYmC9v0PoamriU8vCw0MZ2"
    private let baseURL = "https://api.mobygames.com/v1"
    static let share = MobyGamesService()

    func fetchGames(completion: @escaping (Result<[Game], Error>) -> Void) {
        let url = "https://api.mobygames.com/v1/games?api_key=moby_8BhL8vYmC9v0PoamriU8vCw0MZ2"
        
        AF.request(url).validate().responseDecodable(of: [Game].self) { response in
            switch response.result {
            case .success(let games):
                completion(.success(games))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // Add similar functions for fetching genres, platforms, etc.
}


