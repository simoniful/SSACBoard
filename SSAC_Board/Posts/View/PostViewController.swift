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
        let rightButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.fill"), style: .plain, target: self, action: #selector(rightButtonClicked))
        self.navigationItem.rightBarButtonItem = rightButton
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .black
    }

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
    
    @objc func rightButtonClicked() {
        self.navigationController?.pushViewController(ChangePasswordViewController(), animated: true)
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let convertDate = dateFormatter.date(from: data.createdAt)
        let myDateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "yyyy년 MM월 dd일 a hh시 mm분"
        myDateFormatter.locale = Locale(identifier:"ko_KR")
        let convertStr = myDateFormatter.string(from: convertDate!)
        cell.createDateLabel.text = convertStr
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
