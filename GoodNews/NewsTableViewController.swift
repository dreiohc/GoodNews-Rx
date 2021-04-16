//
//  NewsTableViewController.swift
//  GoodNews
//
//  Created by Myron Dulay on 4/15/21.
//

import UIKit
import RxSwift
import RxCocoa

private let reuseIdentifier = "ArticleTableViewCell"

class NewsTableViewController: UITableViewController {
  
  // MARK: - Properties
  
  private var articles = [Article]() {
    didSet {
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
  
  let disposeBag = DisposeBag()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.prefersLargeTitles = true

    populateNews()
  }
  
  // MARK: - API
  
  private func populateNews() {
    
    Observable.just(NEWS_URL)
      .flatMap { url -> Observable<Data> in // sometimes data type result are not identified by Swift in Rx.
        let request = URLRequest(url: NEWS_URL)
        return URLSession.shared.rx.data(request: request) // returns a url request response data.
      }.map { data -> [Article]? in
        return try? JSONDecoder().decode(ArticleList.self, from: data).articles // decode the request data.
      }.subscribe(onNext: { [weak self] articles in
        if let articles = articles {
          self?.articles = articles
        }
      }).disposed(by: disposeBag)
    
  }
  
  // MARK: - Actions
  
  
  
  // MARK: - Helpers
}


// MARK: - UITableViewDataSource

extension NewsTableViewController {
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ArticleTableViewCell else { fatalError() }
    cell.titleLabel.text = articles[indexPath.row].title
    cell.descriptionLabel.text = articles[indexPath.row].description
    return cell
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return articles.count
  }
  
}

// MARK: - UITableViewDelegate

extension NewsTableViewController {
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
  
}
