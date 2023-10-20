//
//  JKObserveLifeCycleDataViewController2.swift
//  JKPacket_Example
//
//  Created by jack on 2023/10/20.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import JKPacket
import SnapKit
import RxSwift

class JKObserveLifeCycleDataViewController2:JKLifeCycleViewController {
    var lifecycleAge = JKDefaultLiveData<Int>()
    private lazy var btn1:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("lifecycleAge + 1", for: .normal)
        btn.backgroundColor = .blue
        btn.addTarget(self, action: #selector(btnClicked1), for: .touchUpInside)
        return btn
    }()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        lifecycleAge.observe(owner: self, onSubject: { subject in
            return subject.debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
        }) { value in
            print("JKObserveLifeCycleDataViewController value：\(String(describing: value))")
        }
        
        view.addSubview(btn1)
        
        
        btn1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.size.equalTo(CGSize(width: 150, height: 30))
        }
        
       
        
    }
    
    
    
    @objc  private func btnClicked1() {
        if lifecycleAge.value == nil {
            lifecycleAge.value = 1
        } else {
            lifecycleAge.value? += 1
        }
      }
      
     
    
}
