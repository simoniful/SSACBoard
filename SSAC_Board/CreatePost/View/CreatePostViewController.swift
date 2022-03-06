//
//  CreatePostViewController.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2022/01/03.
//

import UIKit
import RxCocoa
import RxSwift

class CreatePostViewController: UIViewController {
    let createPostView = CreatePostView()
    let viewModel = CreateViewModel()
    let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = createPostView
        setNavigation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    func setNavigation() {
        title = "새 글쓰기"
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem =
        UIBarButtonItem(customView: createPostView.closeButton)
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem =
        UIBarButtonItem(customView: createPostView.doneButton)
    }
    
    func bind() {
        createPostView.textView.rx.text
            .orEmpty
            .bind(to: viewModel.text)
            .disposed(by: disposeBag)
       
        createPostView.closeButton.rx.tap
            .subscribe { [weak self] (_) in
                guard let self = self else { return }
                self.dismiss(animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        createPostView.doneButton.rx.tap
            .subscribe { [weak self] (_) in
                guard let self = self else { return }
                let alert = UIAlertController(title: "게시물 작성", message: "해당 내용으로 게시물을 작성하시겠습니까?", preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .default) { (action: UIAlertAction!) -> Void in
                    self.viewModel.requestCreatePost { data in
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                alert.addAction(ok)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
    }

}

