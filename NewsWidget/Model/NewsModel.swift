//
//  NewsModel.swift
//  NewsWidget
//
//  Created by MacBook J&J  on 6/07/22.
//

import Foundation

// MARK: - News
struct NewsModel: Codable {
    var articles: [Article]
}

// MARK: - Article
struct Article: Codable {
    let author: String?
    let title: String
    let urlToImage: String?
    let publishedAt: String

    enum CodingKeys: String, CodingKey {
        case author, title, urlToImage, publishedAt
    }
}
