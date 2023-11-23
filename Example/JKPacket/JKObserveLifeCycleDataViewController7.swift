//
//  JKObserveLifeCycleDataViewController7.swift
//  JKPacket_Example
//
//  Created by jack on 2023/11/17.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import JKPacket
import SnapKit

class JKObserveLifeCycleDataViewController7:JKLifeCycleViewController {
    var age:Int = 1
    var lifecycleDic = JKLiveDictionary<String,Int>()
    private lazy var btn1:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("lifecycleDic insert", for: .normal)
        btn.backgroundColor = .blue
        btn.addTarget(self, action: #selector(btnClicked1), for: .touchUpInside)
        return btn
    }()
    
    private lazy var btn2:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("lifecycleDic update", for: .normal)
        btn.backgroundColor = .blue
        btn.addTarget(self, action: #selector(btnClicked2), for: .touchUpInside)
        return btn
    }()
    
    
    private lazy var btn3:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("lifecycleDic remove", for: .normal)
        btn.backgroundColor = .blue
        btn.addTarget(self, action: #selector(btnClicked3), for: .touchUpInside)
        return btn
    }()
    
    
    private lazy var btn4:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("lifecycleDic removeAll", for: .normal)
        btn.backgroundColor = .blue
        btn.addTarget(self, action: #selector(btnClicked4), for: .touchUpInside)
        return btn
    }()
    
    
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        lifecycleDic.observe(owner: self) { value in
            print("dic: \(String(describing: value.dic))")
            print("change: \(value.change?.type), keys:\(value.change?.keys)")
            print("***************")
        }
        
        
        view.addSubview(btn1)
        view.addSubview(btn2)
        view.addSubview(btn3)
        view.addSubview(btn4)
        
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
        
       
        
    }
    
    
    @objc  private func btnClicked1() {
        age += 1
        lifecycleDic["key\(age)"] = age
      }
    
    @objc  private func btnClicked2() {
       let _ = lifecycleDic.updateValue(10000, forKey: "key\(age)")
      }
    
    @objc  private func btnClicked3() {
        let _ = lifecycleDic.removeValue(forKey: "key\(age)")
      }
    
    @objc  private func btnClicked4() {
        lifecycleDic.removeAll()
      }
      
}

