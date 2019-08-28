//
//  SearchResult.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 05/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import Foundation

struct SearchResult: Decodable {
  let resultCount: Int
  let results: [AppSearchResult]
}

struct AppSearchResult: Decodable {
  let trackId: Int
  let trackName: String
  let primaryGenreName: String
  var averageUserRating: Float?
  let artworkUrl100: String
  var screenshotUrls: [String]?
  var formattedPrice: String?
  var description: String?
  var releaseNotes: String?
  var artistName: String?
  var collectionName: String?
}
