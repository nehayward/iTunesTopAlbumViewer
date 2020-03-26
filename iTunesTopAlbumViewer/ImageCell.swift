//
//  AlbumViewCell.swift
//  iTunesTopAlbumViewer
//
//  Created by Nick Hayward on 3/24/20.
//  Copyright © 2020 Nick Hayward. All rights reserved.
//

import Foundation
import UIKit

class AlbumViewCell: UITableViewCell {
    
    static let reuseIdentifier = "\(type(of: AlbumViewCell.self))"
    
    private var imageDownloader: ImageDownloader

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.imageDownloader = .shared
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        imageView?.image = nil
    }
    
    func configure(with result: FeedResult) {
        textLabel?.text = result.name
        detailTextLabel?.text = result.artistName
        imageDownloader.request(result.artworkURL100) { (result) in
            switch result {
            case .success(let image):
                self.imageView?.image = image
                self.setNeedsLayout()

            case .failure(let error):
                break
            }
        }
    }
}
