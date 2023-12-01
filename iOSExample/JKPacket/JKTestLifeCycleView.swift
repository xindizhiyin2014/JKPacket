//
//  JKTestLifeCycleView.swift
//  JKPacket_Example
//
//  Created by jack on 2023/10/20.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import SnapKit
import RxSwift
import JKPacket

class JKTestLifeCycleView: JKLifeCycleView {
    var lifecycleAge = JKDefaultLiveData<Int>()
    var  label:UILabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        lifecycleAge.observe(owner: self) { value in
            print("JKTestLifeCycleView value: \(String(describing: value))")
        }
        self.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(30)
        }
        label.text = "JKTestLifeCycleView"
        self.backgroundColor = UIColor.green.withAlphaComponent(0.3)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
