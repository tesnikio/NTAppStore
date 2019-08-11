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
    
    func fetchAppsSearch(searchTerm: String, completion: @escaping (SearchResult?, Error?) -> ()) {
        let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&entity=software"
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    func fetchAppGroupByType(type: FeedType , completion: @escaping (AppGroup?, Error?) -> ()) {
        let urlString = createUrlStringForFeedType(type: type)
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    func fetchHeaders(completion: @escaping ([HeaderApp]?, Error?) -> ()) {
        let urlString = "https://api.letsbuildthatapp.com/appstore/social"
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    func fetchGenericJSONData<T: Decodable>(urlString: String, completion: @escaping (T?, Error?) -> ()) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(result, nil)
            } catch let jsonError {
                print("Failed to fetch apps: ", jsonError)
            }
        }.resume()
    }
    
    func createUrlStringForFeedType(type: FeedType) -> String {
        let urlString = "https://rss.itunes.apple.com/api/v1/us/ios-apps/\(type.rawValue)/all/25/explicit.json"
        return urlString
    }
}
