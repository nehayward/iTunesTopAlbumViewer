//
//  NetworkManager.swift
//  iTunesTopAlbumViewer
//
//  Created by Nick Hayward on 3/24/20.
//  Copyright © 2020 Nick Hayward. All rights reserved.
//

import Foundation
import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request(_ endpoint: Endpoint,
                 then handler: @escaping (Result<[FeedResult], NetworkError>) -> (),
                 handledOn resultQueue: DispatchQueue = .main) {
        guard let url = endpoint.url else {
            return handler(.failure(NetworkError.invalidURL))
        }
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { (data, response, err) in
            guard let httpResponse = response as? HTTPURLResponse else {
                handler(.failure(NetworkError.badRequest))
                return
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                handler(.failure(NetworkError.badRequest))
                return
            }
            
            guard let data = data else {
                handler(.failure(NetworkError.noData))
                return
            }
            
            
            guard let feed = try? JSONDecoder().decode(Feed.self, from: data) else {
                handler(.failure(NetworkError.decode))
                return
            }
            
            resultQueue.async {
                handler(.success(feed.results))
            }
        }
        
        task.resume()
    }
    
    func downloadImage(_ url: String,
                       then handler: @escaping (Result<UIImage, Error>) -> (),
                       handledOn resultQueue: DispatchQueue = .main) {
        
        guard let url = URL(string: url) else {
            return handler(.failure(NetworkError.invalidURL))
        }
        
        let request = URLRequest(url: url)
        let task =  session.dataTask(with: request) { (data, response, err) in
            guard let httpResponse = response as? HTTPURLResponse else {
                handler(.failure(NetworkError.badRequest))
                return
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                handler(.failure(NetworkError.badRequest))
                return
            }
            
            guard let data = data else {
                handler(.failure(NetworkError.noData))
                return
            }
            
            guard let image = UIImage(data: data) else {
                handler(.failure(NetworkError.decode))
                return
            }
            
            resultQueue.async {
                handler(.success(image))
            }
        }
        
        task.resume()
    }
}

extension NetworkManager {
    static var getFeed: FeedResultLoadingFunction  = { handler in
        NetworkManager.shared.request(.topAlbums(), then: { (result) in
            switch result {
            case .success(let feedresults):
                handler(feedresults)
            case .failure(let error):
                handler([])
            }
        }, handledOn: .main)
    }
    
    static var getImage: ImageLoadingFunction  = { url, handler in
        NetworkManager.shared.downloadImage(url, then: { (result) in
            switch result {
            case .success(let image):
                handler(image)
            case .failure(let error):
                break
            }
        })
    }
}
