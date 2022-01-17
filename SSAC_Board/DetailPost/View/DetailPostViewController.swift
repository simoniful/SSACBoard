//
//  DetailPostViewController.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2022/01/03.
//

import UIKit
import Toast

class DetailPostViewController: UIViewController {

    var postData: Post?
    
    let detailPostView = DetailPostView()
    let viewModel = DetailPostViewModel()
    
    override func loadView() {
        self.view = detailPostView
        let rightButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(rightButtonClicked))
        self.navigationItem.rightBarButtonItem = rightButton
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .black
    }
    
    // [To-Do] TextView 입력시 keyboard 등장에 따른 뷰 동적 변화 notification
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let postData = postData else { return }
        let cellNibName = UINib(nibName: DetailPostTableViewCell.identifier, bundle: nil)
        detailPostView.tableView.register(DetailPostTableViewHeader.self, forHeaderFooterViewReuseIdentifier: DetailPostTableViewHeader.identifier)
        detailPostView.tableView.register(cellNibName, forCellReuseIdentifier: DetailPostTableViewCell.identifier)
        detailPostView.tableView.delegate = self
        detailPostView.tableView.dataSource = self
        viewModel.requestCommentData(postData.id, completion: {
            self.detailPostView.tableView.reloadData()
        })
        
        viewModel.commentText.bind { text in
            self.detailPostView.textView.text = text
        }
        
        detailPostView.textView.delegate = self
        detailPostView.textView.isScrollEnabled = false
        
        detailPostView.submitButton.addTarget(self, action: #selector(submitButtonClicked), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let postData = postData else { return }
        viewModel.requestCommentData(postData.id, completion: {
            self.detailPostView.tableView.reloadData()
        })
    }
    
    @objc func rightButtonClicked() {
        guard let postId = postData?.user.id.description else { return }
        let myId = UserDefaults.standard.string(forKey: "id")!
        if(myId != postId) {
            self.view.makeToast("작성한 게시물이 아니라 수정할 수 없습니다")
        } else {
            let actionsheet = UIAlertController(title: "게시물 수정", message: "수정 또는 삭제가 가능합니다", preferredStyle: .actionSheet)
            let update = UIAlertAction(title: "수정", style: .default) { (action: UIAlertAction) in
                let vc = UpdateViewController()
                vc.postData = self.postData
                vc.btnActionHandler = { data in
                    self.view.makeToast("게시물 수정 완료!")
                    guard let data = data as? Post else { return }
                    self.postData = data
                    self.detailPostView.tableView.reloadData()
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
            let delete = UIAlertAction(title: "삭제", style: .default) { (action: UIAlertAction) in
                let alert = UIAlertController(title: "게시물 삭제", message: "해당 게시물을 삭제하시겠습니까?\n삭제된 게시물은 복구할 수 없습니다", preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .default) { (action: UIAlertAction) in
                    guard let postData = self.postData else { return }
                    self.viewModel.requestDeletePost(postData.id) {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
                let cancel = UIAlertAction(title: "취소", style: .destructive, handler: nil)
                alert.addAction(ok)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
            }
            let cancel = UIAlertAction(title: "취소", style: .destructive, handler: nil)
            actionsheet.addAction(update)
            actionsheet.addAction(delete)
            actionsheet.addAction(cancel)
            self.present(actionsheet, animated: true, completion: nil)
        }
    }
    
    @objc func submitButtonClicked() {
        guard let postData = postData else { return }
        viewModel.requestCreateComment(postData.id) {
            self.detailPostView.tableView.reloadData()
            self.detailPostView.textView.text = ""
            self.view.makeToast("댓글 작성 완료!")
        }
    }
}

extension DetailPostViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        viewModel.commentText.value = textView.text ?? ""
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
}

extension DetailPostViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailPostTableViewCell.identifier, for: indexPath) as? DetailPostTableViewCell else {
            return UITableViewCell()}
        let data = viewModel.cellForRowAt(at: indexPath)
        cell.nickNameLabel.text = data.user.username
        cell.contentLabel.text = data.comment
        cell.updateButtonAction = { [unowned self] in
            let commentId = data.user.id
            let myId = UserDefaults.standard.string(forKey: "id")!
            if(myId != commentId.description) {
                self.view.makeToast("작성한 댓글이 아니라 수정할 수 없습니다")
            } else {
                let actionsheet = UIAlertController(title: "댓글 수정", message: "수정 또는 삭제가 가능합니다", preferredStyle: .actionSheet)
                let update = UIAlertAction(title: "수정", style: .default) { (action: UIAlertAction) in
                    let vc = UpdateViewController()
                    vc.commentData = data
                    vc.btnActionHandler = { data in 
                        self.view.makeToast("댓글 수정 완료!")
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                let delete = UIAlertAction(title: "삭제", style: .default) { (action: UIAlertAction) in
                    let alert = UIAlertController(title: "댓글 삭제", message: "해당 댓글을 삭제하시겠습니까?\n삭제된 댓글은 복구할 수 없습니다", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "확인", style: .default) { (action: UIAlertAction) in
                        self.viewModel.requestDeleteComment(data.id) {
                            self.view.makeToast("댓글 삭제 완료!")
                            self.detailPostView.tableView.reloadData()
                        }
                    }
                    let cancel = UIAlertAction(title: "취소", style: .destructive, handler: nil)
                    alert.addAction(ok)
                    alert.addAction(cancel)
                    self.present(alert, animated: true, completion: nil)
                }
                let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                actionsheet.addAction(update)
                actionsheet.addAction(delete)
                actionsheet.addAction(cancel)
                self.present(actionsheet, animated: true, completion: nil)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: DetailPostTableViewHeader.identifier) as? DetailPostTableViewHeader else { return UITableViewHeaderFooterView() }
        header.contentLabel.text = self.postData?.text
        header.nickNameLabel.text = self.postData?.user.username
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let convertDate = dateFormatter.date(from: self.postData!.createdAt)
        let myDateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "yyyy년 MM월 dd일 a hh시 mm분"
        myDateFormatter.locale = Locale(identifier:"ko_KR")
        let convertStr = myDateFormatter.string(from: convertDate!)
        header.dateLabel.text = convertStr
        header.commentCountLabel.text = viewModel.numberOfRowInSection != 0 ? "댓글 \(viewModel.numberOfRowInSection)" : "댓글이 없습니다"
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
