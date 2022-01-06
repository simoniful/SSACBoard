//
//  PostViewController.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2021/12/31.
//

import UIKit

class PostViewController: UIViewController {
    let postView = PostView()
    let viewModel = PostViewModel()
    
    override func loadView() {
        self.view = postView
    }
    
    // [To-Do] 네비게이션바 우측 버튼을 통해 비밀번호 변경 view 이동 구현, Date 형식 변경
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "새싹농장"
        postView.tableView.delegate = self
        postView.tableView.dataSource = self
        postView.createPostViewButton.addTarget(self, action: #selector(createPostViewButtonClicked), for: .touchUpInside)
        let nibName = UINib(nibName: PostTableViewCell.identifier, bundle: nil)
        postView.tableView.register(nibName, forCellReuseIdentifier: PostTableViewCell.identifier)
        viewModel.requestPosts {
            self.postView.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.requestPosts {
            self.postView.tableView.reloadData()
        }
    }
    
    @objc func createPostViewButtonClicked() {
        let nav =  UINavigationController(rootViewController: CreatePostViewController())
        nav.modalTransitionStyle = .coverVertical
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
}

extension PostViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as? PostTableViewCell else {
            return UITableViewCell()}
        let data = viewModel.cellForRowAt(at: indexPath)
        cell.nickNameLabel.text = data.user.username
        cell.contentLabel.text = data.text
        cell.createDateLabel.text = data.updatedAt
        cell.commentCountLabel.text = data.comments.count == 0 ? "댓글쓰기" : "댓글 \(data.comments.count)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailPostViewController()
        vc.postData = viewModel.cellForRowAt(at: indexPath)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
