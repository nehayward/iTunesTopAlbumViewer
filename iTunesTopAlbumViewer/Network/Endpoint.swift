//
//  Endpoint.swift
//  iTunesTopAlbumViewer
//
//  Created by Nick Hayward on 3/24/20.
//  Copyright © 2020 Nick Hayward. All rights reserved.
//

import Foundation

struct Endpoint {
    let path: String
}

extension Endpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "rss.itunes.apple.com"
        components.path = path
        
        return components.url
    }
}
