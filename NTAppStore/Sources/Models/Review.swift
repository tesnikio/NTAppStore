//
//  Review.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 14/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import Foundation

struct Review: Decodable {
    let feed: ReviewFeed
}

struct ReviewFeed: Decodable {
    let entry: [Entry]
}

struct Entry: Decodable {
    let author: Author
    let title: Label
    let content: Label
    let rating: Label
    
    private enum CodingKeys: String, CodingKey {
        case author
        case title
        case content
        case rating = "im:rating"
    }
}

struct Author: Decodable {
    let name: Label
}

struct Label: Decodable {
    let label: String
}
