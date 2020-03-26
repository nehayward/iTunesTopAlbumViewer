//
//  NetworkError.swift
//  iTunesTopAlbumViewer
//
//  Created by Nick Hayward on 3/25/20.
//  Copyright © 2020 Nick Hayward. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case noData

    case badRequest
    
    case decode
    
    case invalidURL
    
    case network(Error)
}


