//
//  JKObserveLifeCycleDataViewController.swift
//  JKPacket_Example
//
//  Created by jack on 2023/10/18.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import JKPacket
import SnapKit

class JKObserveLifeCycleDataViewController:JKLifeCycleViewController {
    var lifecycleAge = JKDefaultLiveData<Int>()
    private lazy var btn1:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("lifecycleAge + 1", for: .normal)
        btn.backgroundColor = .blue
        btn.addTarget(self, action: #selector(btnClicked1), for: .touchUpInside)
        return btn
    }()
    
    private lazy var btn2:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("跳转下一页", for: .normal)
        btn.backgroundColor = .blue
        btn.addTarget(self, action: #selector(btnClicked2), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        lifecycleAge.observe(owner: self) { value in
            print("JKObserveLifeCycleDataViewController value：\(String(describing: value))")
        }
        
        view.addSubview(btn1)
        view.addSubview(btn2)
        
        btn1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.size.equalTo(CGSize(width: 150, height: 30))
        }
        
        btn2.snp.makeConstraints { make in
            make.top.equalTo(btn1.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.size.equalTo(btn1)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("JKObserveLifeCycleDataViewController viewWillAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("JKObserveLifeCycleDataViewController viewWillDisappear")
        
    }
    
    @objc  private func btnClicked1() {
        if lifecycleAge.value == nil {
            lifecycleAge.value = 1
        } else {
            lifecycleAge.value? += 1
        }
      }
      
     @objc private func btnClicked2() {
         let vc = JKObserveLifeCycleDataViewController1()
         vc.changeAgeBlock = { [weak self] age in
             print("set age now age:\(age)")
             self?.lifecycleAge.value = age
//             print("JKObserveLifeCycleDataViewController current lifecycleAge \(String(describing: self?.lifecycleAge.value))")
         }
         
         self.navigationController?.pushViewController(vc, animated: true)
      }
    
    
}
