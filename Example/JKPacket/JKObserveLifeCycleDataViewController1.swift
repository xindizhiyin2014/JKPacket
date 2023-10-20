//
//  JKObserveLifeCycleDataViewController1.swift
//  JKPacket_Example
//
//  Created by jack on 2023/10/18.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import SnapKit

class JKObserveLifeCycleDataViewController1:UIViewController {
    
    var changeAgeBlock:((_ age:Int) ->Void)?
    
    private lazy var btn1:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("赋值", for: .normal)
        btn.backgroundColor = .blue
        btn.addTarget(self, action: #selector(btnClicked1), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(btn1)
        btn1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.size.equalTo(CGSize(width: 100, height: 30))
        }
    }
    
    
    @objc  private func btnClicked1() {
       changeAgeBlock?(10000)
      }
}
