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

//    func fetchGames(completion: @escaping (Result<[Game], Error>?) -> Void) {
//        let url = "https://api.mobygames.com/v1/games?api_key=moby_8BhL8vYmC9v0PoamriU8vCw0MZ2"
//
//        AF.request(url).responseJSON { response in
//                    switch response.result {
//                    case .success(let value):
//                        do {
//                            // Giải mã dữ liệu JSON thành dictionary
//                            if let dict = value as? [String: Any],
//                               let data = dict["games"] as? [[String: Any]] {
//                                // Từ dictionary, giải mã ra mảng của `Game`
//                                let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
//                                let games = try JSONDecoder().decode([Game].self, from: jsonData)
//                                completion(.success(games))
//                            } else {
//                                // Nếu không tìm thấy key "data", trả về lỗi
//                                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing 'data' key in JSON"])))
//                            }
//                        } catch {
//                            completion(.failure(error))
//                        }
//                    case .failure(let error):
//                        completion(.failure(error))
//                    }
//                }
//    }

    // Add similar functions for fetching genres, platforms, etc.
    
    
    struct GameResponse: Decodable {
        let games: [Game]
    }

    // Service class để tương tác với API
    
        // Hàm để lấy dữ liệu từ API
        func fetchGames(completion: @escaping (Result<[Game], Error>) -> Void) {
            // Đường dẫn của API mà bạn muốn gọi
            let url = "https://api.mobygames.com/v1/games?api_key=moby_8BhL8vYmC9v0PoamriU8vCw0MZ2"
            
            // Sử dụng Alamofire để gọi API
            AF.request(url).responseDecodable(of: GameResponse.self) { response in
                switch response.result {
                case .success(let gameResponse):
                    // Trả về mảng game nếu giải mã thành công
                    completion(.success(gameResponse.games))
                case .failure(let error):
                    // Trả về lỗi nếu có vấn đề xảy ra
                    completion(.failure(error))
                }
            }
        }
    
    
}


