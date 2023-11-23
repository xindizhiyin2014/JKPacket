//
//  JKLifecycleViewController8.swift
//  JKPacket_Example
//
//  Created by jack on 2023/11/22.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import JKPacket

public class JKLifecycleViewController8 : UIViewController {
    private var appData = JKDefaultLiveData<Int>()
    var age:Int = 1
    var timer:Timer?

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        appData.observe(owner: JKProcessLifecycleOwner.shared) { value in
            print("value: \(String(describing: value))")
        }
        timer = Timer.init(timeInterval: 1, repeats: true) { [weak self] _ in
            self?.age += 1
            print("age: \(String(describing: self?.age))")
            self?.appData.value = self?.age
        }
        RunLoop.current.add(timer!, forMode: .commonModes)
        timer?.fire()
        
        let lifecycle:JKLifecycle = JKProcessLifecycleOwner.shared.getLifecycle()
        let observer:JKDefaultLifecycleObserver = JKDefaultLifecycleObserver()
        observer.stateChangedBlock = {[weak self] (source:JKLifecycleOwner,event:JKLifecycle.Event) in
            print("event: \(event)")
            if event == .ON_PAUSE {
                self?.age = 10000
                self?.appData.value = self?.age
                self?.timer?.invalidate()
                self?.timer = nil
            }
        }
        lifecycle.addObserver(observer)
    }
    
}
