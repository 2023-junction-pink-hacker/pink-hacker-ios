//
//  ViewController.swift
//  PinkHacker
//
//  Created by Woody Lee on 2023/08/19.
//

import UIKit
import SnapKit
import Combine

class ViewController: UIViewController {
    var label: UILabel!
    var cancellable: AnyCancellable?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        cancellable = TestAPIRequest().publisher().sink(receiveCompletion: { _ in },
                                      receiveValue: { [weak self] response in
            self?.label.text = response.name
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel()
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        self.label = label
    }
    
}
