//
//  JKObserveLifeCycleDataViewController4.swift
//  JKPacket_Example
//
//  Created by jack on 2023/10/20.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import JKPacket
import SnapKit

class JKObserveLifeCycleDataViewController4:JKLifeCycleViewController {
    var lifecycleAge = JKReplayLiveData<Int>()
    
    
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
        lifecycleAge.observe(owner: self,bufferSize: 2) { value in
            print("11 value：\(String(describing: value))")
        }
        
        lifecycleAge.observe(owner: self,bufferSize: 0) { value in
            print("22 value：\(String(describing: value))")
        }
        
        view.addSubview(btn2)
        
        btn2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.size.equalTo(CGSize(width: 150, height: 30))
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
    
      
     @objc private func btnClicked2() {
         let vc = JKObserveLifeCycleDataViewController1()
         vc.changeAgeBlock = { [weak self] age in
             print("set age now age:\(age)")
             self?.lifecycleAge.value = age
         }
         
         self.navigationController?.pushViewController(vc, animated: true)
      }
    
    
}
