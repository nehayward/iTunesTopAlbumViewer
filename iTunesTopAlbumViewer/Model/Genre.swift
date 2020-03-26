//
//  Genre.swift
//  iTunesTopAlbumViewer
//
//  Created by Nick Hayward on 3/25/20.
//  Copyright © 2020 Nick Hayward. All rights reserved.
//

import Foundation

struct Genre: Codable {
    let genreID, name: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case genreID = "genreId"
        case name, url
    }
}
