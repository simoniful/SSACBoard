//
//  DetailPostViewController.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2022/01/03.
//

import UIKit
import Toast
import SnapKit
import RxSwift
import RxCocoa

class DetailPostViewController: UIViewController {

    var postData: Post?
    
    let detailPostView = DetailPostView()
    let viewModel = DetailPostViewModel()
    let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = detailPostView
        setNavigation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let postData = postData else { return }
        viewModel.requestCommentData(postData.id)
        bind()
        addKeyboardNotification(showSelector: #selector(keyboardWillShow), hideSelector: #selector(keyboardWillHide))
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        detailPostView.tableView.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let postData = postData else { return }
        viewModel.requestCommentData(postData.id)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeForKeyboardNotifications()
    }
    
    func setNavigation() {
        title = "게시물"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: detailPostView.backButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: detailPostView.updateButton)
    }
    
    func bind() {
        viewModel.commentsObservable
            .bind(to: detailPostView.tableView.rx.items) { (tableView, row, element) in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailPostTableViewCell.identifier) as? DetailPostTableViewCell else {
                    return UITableViewCell()}
                cell.selectionStyle = .none
                cell.nickNameLabel.text = element.user.username
                cell.contentLabel.text = element.comment
                cell.updateButtonAction = { [weak self] in
                    guard let self = self else { return }
                    let commentId = element.user.id
                    let myId = UserDefaults.standard.string(forKey: "id")!
                    if(myId != commentId.description) {
                        self.view.makeToast("작성한 댓글이 아니라 수정할 수 없습니다")
                    } else {
                        let actionsheet = UIAlertController(title: "댓글 수정", message: "수정 또는 삭제가 가능합니다", preferredStyle: .actionSheet)
                        let update = UIAlertAction(title: "수정", style: .default) { (action: UIAlertAction) in
                            let vc = UpdateViewController()
                            vc.commentData = element
                            vc.btnActionHandler = { data in
                                self.view.makeToast("댓글 수정 완료!")
                            }
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        let delete = UIAlertAction(title: "삭제", style: .default) { (action: UIAlertAction) in
                            let alert = UIAlertController(title: "댓글 삭제", message: "해당 댓글을 삭제하시겠습니까?\n삭제된 댓글은 복구할 수 없습니다", preferredStyle: .alert)
                            let ok = UIAlertAction(title: "확인", style: .default) { (action: UIAlertAction) in
                                self.viewModel.requestDeleteComment(element.id) {
                                    self.view.makeToast("댓글 삭제 완료!")
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
            .disposed(by: disposeBag)
        
        detailPostView.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        detailPostView.textView.rx.text
            .orEmpty
            .bind(to: viewModel.commentText)
            .disposed(by: disposeBag)
        
        detailPostView.textView.rx.didChange
            .bind { [weak self](_) in
                guard let self = self else { return }
                let size = CGSize(width: self.view.frame.width, height: .infinity)
                let estimatedSize = self.detailPostView.textView.sizeThatFits(size)
                self.detailPostView.textView.constraints.forEach { (constraint) in
                    if constraint.firstAttribute == .height {
                        constraint.constant = estimatedSize.height
                    }
                }
            }
            .disposed(by: disposeBag)
        
        detailPostView.submitButton.rx.tap
            .subscribe { [weak self] (_) in
                guard let self = self else { return }
                guard let postData = self.postData else { return }
                self.viewModel.requestCreateComment(postData.id) {
                    self.detailPostView.textView.text = ""
                    self.view.makeToast("댓글 작성 완료!")
                }
            }
            .disposed(by: disposeBag)
                
        detailPostView.updateButton.rx.tap
            .subscribe { [weak self] (_) in
                guard let self = self else { return }
                guard let postId = self.postData?.user.id.description else { return }
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
                    let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                    actionsheet.addAction(update)
                    actionsheet.addAction(delete)
                    actionsheet.addAction(cancel)
                    self.present(actionsheet, animated: true, completion: nil)
                }
            }
            .disposed(by: disposeBag)
        
        detailPostView.backButton.rx.tap
            .subscribe { [weak self](_) in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func addKeyboardNotification(showSelector: Selector, hideSelector: Selector) {
        NotificationCenter.default.addObserver(
            self,
            selector: showSelector,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: hideSelector,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    private func removeForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keybaordRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keybaordRectangle.height
            self.detailPostView.writeStack.snp.updateConstraints {
                $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-keyboardHeight + 15)
                $0.leading.equalToSuperview().offset(15)
                $0.trailing.equalToSuperview().offset(-15)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        self.detailPostView.writeStack.snp.updateConstraints {
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-15)
        }
        self.view.layoutIfNeeded()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension DetailPostViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: DetailPostTableViewHeader.identifier) as? DetailPostTableViewHeader else { return UITableViewHeaderFooterView() }
        header.contentLabel.text = self.postData?.text
        header.nickNameLabel.text = self.postData?.user.username
        header.dateLabel.text = self.postData?.createdAt.toDate
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
