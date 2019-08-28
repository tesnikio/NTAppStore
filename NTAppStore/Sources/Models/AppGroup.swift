//
//  AppGroup.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 09/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import Foundation

struct AppGroup: Decodable {
  let feed: Feed
}

struct Feed: Decodable {
  let title: String
  let results: [FeedResult]
}

struct FeedResult: Decodable {
  let id: String
  let artistName: String
  let name: String
  let artworkUrl100: String
}
