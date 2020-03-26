//
//  Endpoint+Extensions.swift
//  iTunesTopAlbumViewer
//
//  Created by Nick Hayward on 3/24/20.
//  Copyright © 2020 Nick Hayward. All rights reserved.
//

import Foundation

extension Endpoint {
    static func topAlbums(number: Int = 100) -> Endpoint {
        return Endpoint(
            path: "/api/v1/us/apple-music/top-albums/all/\(number)/explicit.json"
        )
    }
}

