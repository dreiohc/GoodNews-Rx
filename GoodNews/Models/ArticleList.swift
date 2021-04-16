//
//  ArticleList.swift
//  GoodNews
//
//  Created by Myron Dulay on 4/16/21.
//

import Foundation

struct ArticleList: Decodable {
  let articles: [Article]
}

extension ArticleList {
  
  static var all: Resource<ArticleList> = {
    return Resource(url: NEWS_URL)
  }()
  
}
