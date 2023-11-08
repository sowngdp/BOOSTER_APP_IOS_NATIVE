import Foundation

// MARK: - Game
struct Game: Decodable {
    let alternateTitles: [AlternateTitles]?
    let description: String?
    let gameId: Int
    let genres: [Genre]
    let mobyScore: Double?
    let mobyURL: String
    let numVotes: Int
    let officialURL: String?
    let platforms: [Platform]
    let sampleCover: Cover
    let sampleScreenshots: [Screenshot]
    let title: String

    private enum CodingKeys: String, CodingKey {
        case alternateTitles = "alternate_titles"
        case description
        case gameId = "game_id"
        case genres
        case mobyScore = "moby_score"
        case mobyURL = "moby_url"
        case numVotes = "num_votes"
        case officialURL = "official_url"
        case platforms
        case sampleCover = "sample_cover"
        case sampleScreenshots = "sample_screenshots"
        case title
    }
}

