//
//  FeedResult.swift
//  iTunesTopAlbumViewer
//
//  Created by Nick Hayward on 3/25/20.
//  Copyright © 2020 Nick Hayward. All rights reserved.
//

import Foundation

struct FeedResult: Codable {
    let artistName, id, releaseDate, name: String
    let kind: String
    let copyright: String
    let artistID: String
    let contentAdvisoryRating: String?
    let artistURL: String
    let artworkURL100: String
    let genres: [Genre]
    let url: String?

    enum CodingKeys: String, CodingKey {
        case artistName, id, releaseDate, name, kind, copyright
        case artistID = "artistId"
        case contentAdvisoryRating
        case artistURL = "artistUrl"
        case artworkURL100 = "artworkUrl100"
        case genres, url
    }
}
