//
//  Link.swift
//  iTunesTopAlbumViewer
//
//  Created by Nick Hayward on 3/25/20.
//  Copyright © 2020 Nick Hayward. All rights reserved.
//

import Foundation

struct Link: Codable {
    let linkSelf: String?
    let alternate: String?

    enum CodingKeys: String, CodingKey {
        case linkSelf = "self"
        case alternate = "alternate"
    }
}
