//
//  PostViewController.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2021/12/31.
//

import UIKit
import RxSwift
import RxCocoa

class PostViewController: UIViewController {
    let postView = PostView()
    let viewModel = PostViewModel()
    let disposeBag = DisposeBag()
    let refreshControl = UIRefreshControl()
    
    var start = 0
    var limit = 20
    var counts = 0
    
    override func loadView() {
        self.view = postView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "새싹농장"
        setNavigation()
        bind()
        postView.tableView.refreshControl = refreshControl
        viewModel.requestReadPost(start: start, limit: limit)
        viewModel.requestCountPost { [weak self] (error) in
            guard let self = self else { return }
            if let error = error {
                self.APIErrorHandler(error: error, message: "포스트 정보를 받아오지 못했습니다")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.requestReadPost(start: 0, limit: 20, refresh: true)
        self.viewModel.requestCountPost { [weak self](error) in
            guard let self = self else { return }
            if let error = error {
                self.APIErrorHandler(error: error, message: "포스트 갱신에 실패했습니다.")
            }
        }
    }
    
    func setNavigation() {
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(customView: postView.changePasswordButton)
    }
    
    func bind() {
        viewModel.postsObservable
        .bind(to: postView.tableView.rx.items) { (tableView, row, element) in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier) as? PostTableViewCell else { return UITableViewCell() }
            cell.nickNameLabel.text = element.user.username
            cell.contentLabel.text = element.text
            cell.createDateLabel.text = element.createdAt.toDate
            cell.commentCountLabel.text = element.comments.count == 0 ? "댓글쓰기" : "댓글 \(element.comments.count)"
            cell.selectionStyle = .none
            return cell
        }
        .disposed(by: disposeBag)

        Observable.zip(postView.tableView.rx.modelSelected(Post.self), postView.tableView.rx.itemSelected)
            .bind { (item, indexPath) in
                let vc = DetailPostViewController()
                vc.postData = item
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.errorObservable
           .subscribe { [weak self](error) in
               guard let error = error.element else {
                   return
               }
               self?.APIErrorHandler(error: error, message: "댓글 불러오는 것을 실패했습니다.")
           }
           .disposed(by: disposeBag)
        
        postView.tableView.rx.didScroll
           .debounce(.milliseconds(50), scheduler: ConcurrentMainScheduler.instance)
           .subscribe { [weak self](_) in
               guard let self = self else { return }
               if self.limit == self.counts {
                   return
               }
               
               let offsetY = self.postView.tableView.contentOffset.y
               let contentHeight = self.postView.tableView.contentSize.height
               let currentLimit = self.limit
               var nextLimit = 0
               
               if currentLimit + 20 <= self.counts {
                   nextLimit = 20
               } else {
                   nextLimit = currentLimit + 20 - self.counts
               }
               
               if offsetY > (contentHeight - self.postView.tableView.frame.size.height - 100) && self.limit < self.counts {
                   self.viewModel.requestReadPost(start: currentLimit, limit: nextLimit)
                   self.limit = currentLimit + nextLimit
               }
           }
           .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.viewModel.requestReadPost(start: 0, limit: 20, refresh: true)
                self.viewModel.requestCountPost { [weak self](error) in
                    guard let self = self else { return }
                    if let error = error {
                        self.APIErrorHandler(error: error, message: "포스트 갱신에 실패했습니다.")
                    }
                    self.postView.tableView.refreshControl?.endRefreshing()
                }
            })
            .disposed(by: disposeBag)
        
        postView.changePasswordButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                let vc = ChangePasswordViewController()
                vc.btnActionHandler = {
                    self.view.makeToast("비밀번호가 변경되었습니다")
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        postView.createPostViewButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                let nav =  UINavigationController(rootViewController: CreatePostViewController())
                nav.modalTransitionStyle = .coverVertical
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        viewModel.postCount
            .bind { [weak self](count) in
                self?.counts = count
            }
            .disposed(by: disposeBag)
    }
}




