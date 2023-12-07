//
//  GameService.swift
//  Booster
//
//  Created by Fy Spoti on 07/11/2023.
//

import Foundation
import Alamofire
import AlamofireImage

class MobyGamesService {
    private let apiKey = "moby_8BhL8vYmC9v0PoamriU8vCw0MZ2"
    private let baseURL = "https://api.mobygames.com/v1"
    static let share = MobyGamesService()

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
    
    func fetchGameById(gameId: Int, completion: @escaping (Result<Game, Error>) -> Void) {
            // Đường dẫn của API với tham số tìm kiếm theo game_id
            let url = "\(baseURL)/games/\(gameId)?api_key=\(apiKey)"
            
            // Sử dụng Alamofire để gọi API
            AF.request(url).responseDecodable(of: Game.self) { response in
                switch response.result {
                case .success(let game):
                    // Trả về game nếu giải mã thành công
                    completion(.success(game))
                case .failure(let error):
                    // Trả về lỗi nếu có vấn đề xảy ra
                    completion(.failure(error))
                }
            }
        }
    
    // Hàm để tải hình ảnh từ một đường dẫn link
        func fetchImage(from link: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
            // Sử dụng AlamofireImage để tải hình ảnh từ đường dẫn
            AF.request(link).responseImage { response in
                switch response.result {
                case .success(let image):
                    // Truyền hình ảnh thông qua completion handler nếu tải thành công
                    completion(.success(image))
                case .failure(let error):
                    // Truyền lỗi thông qua completion handler nếu có vấn đề xảy ra
                    completion(.failure(error))
                }
            }
        }
    
}


