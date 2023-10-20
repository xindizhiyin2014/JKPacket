//
//  JKObserveLifeCycleDataViewController5.swift
//  JKPacket_Example
//
//  Created by jack on 2023/10/20.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import JKPacket
import SnapKit

class JKObserveLifeCycleDataViewController5:JKLifeCycleViewController {
    var lifecycleAge = JKDefaultLiveData<Int>()
    private lazy var btn1:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("add lifecycleView", for: .normal)
        btn.backgroundColor = .blue
        btn.addTarget(self, action: #selector(btnClicked1), for: .touchUpInside)
        return btn
    }()
    
    private lazy var btn2:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("remove lifecycleView", for: .normal)
        btn.backgroundColor = .blue
        btn.addTarget(self, action: #selector(btnClicked2), for: .touchUpInside)
        return btn
    }()
    
    private lazy var btn3:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("lifecycleAge + 1", for: .normal)
        btn.backgroundColor = .blue
        btn.addTarget(self, action: #selector(btnClicked3), for: .touchUpInside)
        return btn
    }()
    
    private lazy var lifecycleView:JKTestLifeCycleView = {
       let view = JKTestLifeCycleView()
        view.isUserInteractionEnabled = false
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        lifecycleAge.observe(owner: self) { value in
            print("JKObserveLifeCycleDataViewController value：\(String(describing: value))")
        }
        
        view.addSubview(btn1)
        view.addSubview(btn2)
        view.addSubview(btn3)
        
        
        btn1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.size.equalTo(CGSize(width: 200, height: 30))
        }
        
        btn2.snp.makeConstraints { make in
            make.top.equalTo(btn1.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.size.equalTo(btn1)
        }
        
        btn3.snp.makeConstraints { make in
            make.top.equalTo(btn2.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.size.equalTo(btn2)
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
        print("add to superview")
        if lifecycleView.superview == nil {
            view.addSubview(lifecycleView)
            lifecycleView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
      }
      
     @objc private func btnClicked2() {
         print("remove from superview")
         lifecycleView.removeFromSuperview()
      }
    
     @objc private func btnClicked3() {
         print("changeValue")
         if lifecycleView.lifecycleAge.value == nil {
             lifecycleView.lifecycleAge.value = 1
         } else {
             lifecycleView.lifecycleAge.value? += 1
         }

     }
    
    
}

