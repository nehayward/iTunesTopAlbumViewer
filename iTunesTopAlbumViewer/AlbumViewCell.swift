//
//  AlbumViewCell.swift
//  iTunesTopAlbumViewer
//
//  Created by Nick Hayward on 3/24/20.
//  Copyright © 2020 Nick Hayward. All rights reserved.
//

import Foundation
import UIKit

final class AlbumViewCell: UITableViewCell {
    
    static let reuseIdentifier = "\(type(of: AlbumViewCell.self))"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        imageView?.image = nil
    }
    
    func configure(with result: FeedResult, imageLoading: @escaping ImageLoadingFunction = NetworkManager.getImage) {
        textLabel?.text = result.name
        detailTextLabel?.text = result.artistName
        
        #if DEBUG
        if UserDefaults.standard.bool(forKey: "MockNetwork") {
            MockNetwork.mockImage("") { image in
                self.imageView?.image = image
                self.setNeedsLayout()
            }
            return
        }
        #endif
        
        imageLoading(result.artworkURL100) { image in
            self.imageView?.image = image
            self.setNeedsLayout()
        }
    }
}
