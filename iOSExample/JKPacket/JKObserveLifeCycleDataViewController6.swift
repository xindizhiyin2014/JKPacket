//
//  JKObserveLifeCycleDataViewController6.swift
//  JKPacket_Example
//
//  Created by jack on 2023/11/17.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import JKPacket
import SnapKit

class JKObserveLifeCycleDataViewController6:JKLifeCycleViewController {
    var age:Int = 1
    var lifecycleAges = JKLiveArray<Int>()
    private lazy var btn1:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("lifecycleAges add", for: .normal)
        btn.backgroundColor = .blue
        btn.addTarget(self, action: #selector(btnClicked1), for: .touchUpInside)
        return btn
    }()
    
    private lazy var btn2:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("lifecycleAges insert", for: .normal)
        btn.backgroundColor = .blue
        btn.addTarget(self, action: #selector(btnClicked2), for: .touchUpInside)
        return btn
    }()
    
    
    private lazy var btn3:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("lifecycleAges remoteAt", for: .normal)
        btn.backgroundColor = .blue
        btn.addTarget(self, action: #selector(btnClicked3), for: .touchUpInside)
        return btn
    }()
    
    
    private lazy var btn4:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("lifecycleAges removeAll", for: .normal)
        btn.backgroundColor = .blue
        btn.addTarget(self, action: #selector(btnClicked4), for: .touchUpInside)
        return btn
    }()
    
    private lazy var btn5:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("lifecycleAges removeAll where", for: .normal)
        btn.backgroundColor = .blue
        btn.addTarget(self, action: #selector(btnClicked5), for: .touchUpInside)
        return btn
    }()
    
    private lazy var btn6:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("lifecycleAges subscript", for: .normal)
        btn.backgroundColor = .blue
        btn.addTarget(self, action: #selector(btnClicked6), for: .touchUpInside)
        return btn
    }()
    
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        lifecycleAges.observe(owner: self) { value in
            print("list:\(value.list)\n")
            print("change: type:\(value.change?.type), indexs:\(value.change?.indexs) \n")
            print("***************")
        }
        
        view.addSubview(btn1)
        view.addSubview(btn2)
        view.addSubview(btn3)
        view.addSubview(btn4)
        view.addSubview(btn5)
        view.addSubview(btn6)
        
        btn1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.size.equalTo(CGSize(width: 300, height: 30))
        }
        
        btn2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(btn1.snp.bottom).offset(20)
            make.size.equalTo(CGSize(width: 300, height: 30))
        }
        
        btn3.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(btn2.snp.bottom).offset(20)
            make.size.equalTo(CGSize(width: 300, height: 30))
        }
        
        btn4.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(btn3.snp.bottom).offset(20)
            make.size.equalTo(CGSize(width: 300, height: 30))
        }
        
        btn5.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(btn4.snp.bottom).offset(20)
            make.size.equalTo(CGSize(width: 300, height: 30))
        }
        
        btn6.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(btn5.snp.bottom).offset(20)
            make.size.equalTo(CGSize(width: 300, height: 30))
        }
        
    }
    
    
    @objc  private func btnClicked1() {
        lifecycleAges.append(age)
        age += 1
      }
    
    @objc  private func btnClicked2() {
        lifecycleAges.insert(element: age, at: 1)
        age += 1
      }
    
    @objc  private func btnClicked3() {
        lifecycleAges.remove(at: 1)
      }
    
    @objc  private func btnClicked4() {
        lifecycleAges.removeAll()
      }
      
    
    @objc  private func btnClicked5() {
        lifecycleAges.removeAll { e in
            e < 5
        }
      }
      
    
    @objc  private func btnClicked6() {
        let index = 2
        lifecycleAges[index] = age
        age += 1
      }
      
     
    
}

