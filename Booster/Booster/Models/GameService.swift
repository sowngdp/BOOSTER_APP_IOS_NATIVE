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
    
    struct GenresResponse: Decodable {
        let genres: [Genre]
    }
    
    struct PlatformResponse: Decodable {
        let platform: [Platform]
    }
    
    // Service class để tương tác với API
    
    func fetchPlatforms(completion: @escaping (Result<[Platform], Error>) -> Void) {
        // Đường dẫn của API mà bạn muốn gọi
        let url = "https://api.mobygames.com/v1/platforms?api_key=moby_8BhL8vYmC9v0PoamriU8vCw0MZ2"
        
        // Sử dụng Alamofire để gọi API
        AF.request(url).responseDecodable(of: PlatformResponse.self) { response in
            switch response.result {
            case .success(let platformResponse):
                // Trả về mảng game nếu giải mã thành công
                completion(.success(platformResponse.platform))
            case .failure(let error):
                // Trả về lỗi nếu có vấn đề xảy ra
                completion(.failure(error))
            }
        }
    }
    
    func fetchGenres(completion: @escaping (Result<[Genre], Error>) -> Void) {
        // Đường dẫn của API mà bạn muốn gọi
        let url = "https://api.mobygames.com/v1/genres?api_key=moby_8BhL8vYmC9v0PoamriU8vCw0MZ2"
        
        // Sử dụng Alamofire để gọi API
        AF.request(url).responseDecodable(of: GenresResponse.self) { response in
            switch response.result {
            case .success(let genresResponse):
                // Trả về mảng game nếu giải mã thành công
                completion(.success(genresResponse.genres))
            case .failure(let error):
                // Trả về lỗi nếu có vấn đề xảy ra
                completion(.failure(error))
            }
        }
    }
    
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
    
    
    func fetchGamesByTitle(title: String, completion: @escaping (Result<[Game], Error>) -> Void) {
        // Đường dẫn của API với tham số tìm kiếm tiêu đề
        let url = "\(baseURL)/games?api_key=\(apiKey)&title=\(title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        
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
    
    
    func searchGames(title: String, platformId: Int, genresId: Int, completion: @escaping (Result<[Game], Error>) -> Void) {
        // Đường dẫn của API với tham số tìm kiếm tiêu đề, platform_id, và genres_id
        let url = "(baseURL)/games?api_key=\(apiKey)&title=\(title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&platform=\(platformId)&genre=\(genresId)"

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


