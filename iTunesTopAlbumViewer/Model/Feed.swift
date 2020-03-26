//
//  Feed.swift
//  iTunesTopAlbumViewer
//
//  Created by Nick Hayward on 3/24/20.
//  Copyright © 2020 Nick Hayward. All rights reserved.
//

struct Feed: Codable {
    let title: String
    let id: String
    let author: Author
    let links: [Link]
    let copyright, country: String
    let icon: String
    let updated: String
    let results: [FeedResult]
    
    private enum FeedKeys: String, CodingKey {
        case feed
    }
    
    private enum CodingKeys: String, CodingKey {
        case title
        case id
        case author
        case links
        case copyright
        case country
        case icon
        case updated
        case results
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: FeedKeys.self)
        
        let productValues = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .feed)
        title = try productValues.decode(String.self, forKey: .title)
        id = try productValues.decode(String.self, forKey: .id)
        author = try productValues.decode(Author.self, forKey: .author)
        links = try productValues.decode([Link].self, forKey: .links)
        copyright = try productValues.decode(String.self, forKey: .copyright)
        country = try productValues.decode(String.self, forKey: .country)
        icon = try productValues.decode(String.self, forKey: .icon)
        updated = try productValues.decode(String.self, forKey: .updated)
        results = try productValues.decode([FeedResult].self, forKey: .results)
    }
    
}
