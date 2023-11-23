//
//  JKLifeCycleView.swift
//  JKPacket
//
//  Created by JackLee on 2022/4/3.
//

import Foundation

open class JKLifeCycleView:UIView,JKLifecycleOwner {
 
    var mLifecycleRegistry:JKLifecycleRegistry?
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initLifecycle()
        mLifecycleRegistry?.handleLifecycleEvent(event: .ON_CREATE)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        mLifecycleRegistry?.handleLifecycleEvent(event: .ON_START)
    }
    
    public override func didMoveToWindow() {
        super.didMoveToWindow()
        if window != nil {
            mLifecycleRegistry?.handleLifecycleEvent(event: .ON_RESUME)
        } else {
            mLifecycleRegistry?.handleLifecycleEvent(event: .ON_PAUSE)
        }
    }
    

    public override func removeFromSuperview() {
        super.removeFromSuperview()
        mLifecycleRegistry?.handleLifecycleEvent(event: .ON_STOP)
    }
    
    deinit {
        mLifecycleRegistry?.handleLifecycleEvent(event: .ON_DESTROY)
        
    }
    

    private func initLifecycle() {
        mLifecycleRegistry = JKLifecycleRegistry(provider: self)
        let lifecycle:JKLifecycle = getLifecycle()
        let _ = lifecycle.addObserve { [weak self] source, event in
            if event == .ON_STOP {
//                取消第一响应者，不再响应输入事件
                self?.resignFirstResponder()
            }
        }
    }
    
//    MARK:  - - JKLifecycleOwner - -
    public func getLifecycle() -> JKLifecycle {
        return mLifecycleRegistry!
    }
    
}
