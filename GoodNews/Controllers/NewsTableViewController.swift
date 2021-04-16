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
  
  private var articleListVM: ArticleListViewModel!
  
  let disposeBag = DisposeBag()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.prefersLargeTitles = true

    populateNews()
  }
  
  // MARK: - API
  
  private func populateNews() {
    
    URLRequest.load(resource: ArticleList.all)
      .subscribe(onNext: { [weak self] articleResponse in
        if let articles = articleResponse?.articles {
          self?.articleListVM = ArticleListViewModel(articles)
          DispatchQueue.main.async {
            self?.tableView.reloadData()
          }
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
    
    let article = self.articleListVM.articleAt(indexPath.row)
      
    article
      .title
      .asDriver(onErrorJustReturn: "")
      .drive(cell.titleLabel.rx.text)
      .disposed(by: disposeBag)
    
    article
      .description
      .asDriver(onErrorJustReturn: "")
      .drive(cell.descriptionLabel.rx.text)
      .disposed(by: disposeBag)
    
    return cell
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return articleListVM == nil ? 0: self.articleListVM.articlesVM.count
  }
  
}

// MARK: - UITableViewDelegate

extension NewsTableViewController {
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
  
}
