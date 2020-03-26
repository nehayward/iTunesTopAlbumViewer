//
//  Handlers.swift
//  iTunesTopAlbumViewer
//
//  Created by Nick Hayward on 3/25/20.
//  Copyright © 2020 Nick Hayward. All rights reserved.
//

import Foundation
import UIKit

typealias FeedHandler = ([FeedResult]) -> Void
typealias ImageHandler = (UIImage) -> Void

typealias FeedResultLoadingFunction = (@escaping FeedHandler) -> Void
typealias ImageLoadingFunction = (_ url: String, @escaping ImageHandler) -> Void

