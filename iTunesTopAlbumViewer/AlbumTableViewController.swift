//
//  AlbumTableViewController.swift
//  iTunesTopAlbumViewer
//
//  Created by Nick Hayward on 3/24/20.
//  Copyright © 2020 Nick Hayward. All rights reserved.
//

import UIKit

final class AlbumTableViewController: UITableViewController {
    
    private var feedresults: [FeedResult] = []
    private let feedLoading: FeedResultLoadingFunction
    private lazy var refresh: UIRefreshControl = {
        var refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresh.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return refresh
    }()

    private var state: State = .empty {
        willSet {
            setFooterView(with: newValue)
        }
    }
    
    init(feedLoading: @escaping FeedResultLoadingFunction = NetworkManager.getFeed) {
        self.feedLoading = feedLoading
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchFeed()
    }
    
    func setup() {
        title = "Top 100 Albums"
        tableView.refreshControl = refresh
        tableView.register(AlbumViewCell.self, forCellReuseIdentifier: AlbumViewCell.reuseIdentifier)
    }
    
    func fetchFeed() {
        state = .loading
        
        feedLoading { feed in
            self.feedresults = feed
            self.tableView.reloadData()
            self.state = .loaded
            self.refresh.endRefreshing()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        feedresults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlbumViewCell.reuseIdentifier, for: indexPath) as? AlbumViewCell else {
            preconditionFailure("Failed to cast cell to AlbumViewCell")
        }
        
        let result = feedresults[indexPath.row]
        cell.configure(with: result)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath),
            let image = cell.imageView?.image else {
                return
        }
        let photo = feedresults[indexPath.row]
        navigationController?.pushViewController(DetailPhotoViewController(with: photo, albumCoverImage: image), animated: true)
    }
    
    private func setFooterView(with state: State) {
        switch state {
        case .empty:
            break
        case .failed:
            break
        case .loaded:
            tableView.tableFooterView = nil
        case .loading:
            let activity = UIActivityIndicatorView()
            activity.startAnimating()
            tableView.tableFooterView = activity
        }
        tableView.reloadData()
    }
    
    // MARK: Target/Actions
    @objc func refresh(_ sender: Any) {
        fetchFeed()
    }
}

extension AlbumTableViewController {
    enum State {
        case empty
        case loaded
        case loading
        case failed
    }
}

// MARK: Context Menu
extension AlbumTableViewController {
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
         let index = indexPath.row
         let identifier = "\(index)" as NSString
         let album = self.feedresults[index]
         guard let albumURL = album.url,
             let url = URL(string: albumURL) else { return nil }
         
         return UIContextMenuConfiguration(
             identifier: identifier,
             previewProvider: nil) { _ in
                 let openAlbumAction = UIAction( title: "Open \(album.name) in Music", image: UIImage(systemName: "music.note")) { _ in
                     UIApplication.shared.open(url)
                 }
                 
                 return UIMenu(title: "", image: nil, children: [openAlbumAction])
         }
     }
     
     override func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
         
         guard let identifier = configuration.identifier as? String,
             let index = Int(identifier),
             let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? AlbumViewCell,
             let imageView = cell.imageView else {
                 return nil
         }
         
         return UITargetedPreview(view: imageView)
     }
     
     override func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
         
         guard
             let identifier = configuration.identifier as? String,
             let index = Int(identifier),
             let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)),
             let image = cell.imageView?.image
             else {
                 return
         }
         
         animator.addCompletion {
             let photo = self.feedresults[index]
             self.navigationController?.pushViewController(DetailPhotoViewController(with: photo, albumCoverImage: image), animated: true)
         }
     }
}
