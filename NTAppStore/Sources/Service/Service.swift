//
//  Service.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 05/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import Foundation

enum FeedType: String {
    case topFree = "top-free"
    case topGrossing = "top-grossing"
    case newGames = "new-games-we-love"
}

final class Service {
    private init() {}
    
    static let shared = Service()
    
    func fetchApps(searchTerm: String, completion: @escaping ([Result], Error?) -> ()) {
        let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&entity=software"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to fetch apps: ", error)
                completion([], error)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                completion(searchResult.results, nil)
            } catch let jsonError {
                print("Failed to fetch apps: ", jsonError)
                completion([], jsonError)
            }
            
            }.resume()
    }
    
    func createUrlForFeedType(type: FeedType) -> URL? {
        let urlString = "https://rss.itunes.apple.com/api/v1/us/ios-apps/\(type.rawValue)/all/25/explicit.json"
        return URL(string: urlString)
    }
    
    func fetchByType(type: FeedType , completion: @escaping (AppGroup?, Error?) -> ()) {
        guard let url = createUrlForFeedType(type: type) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let appGroup = try JSONDecoder().decode(AppGroup.self, from: data)
                completion(appGroup, nil)
            } catch let jsonError {
                print("Failed to fetch apps: ", jsonError)
            }
            
        }.resume()
    }
    
    func fetchHeaders(completion: @escaping ([HeaderApp]?, Error?) -> ()) {
        let urlString = "https://api.letsbuildthatapp.com/appstore/social"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let headers = try JSONDecoder().decode([HeaderApp].self, from: data)
                completion(headers, nil)
            } catch let jsonError {
                print("Failed to fetch apps: ", jsonError)
            }
        }.resume()
    }
}
