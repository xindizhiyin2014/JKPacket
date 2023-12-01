//
//  JKLifeCycleViewController.swift
//  JKPacket
//
//  Created by jack on 2023/11/23.
//

import Foundation
import AppKit

open class JKLifeCycleViewController: NSViewController, JKLifecycleOwner {
    final private var mLifecycleRegistry:JKLifecycleRegistry?
    
    public override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        mLifecycleRegistry = JKLifecycleRegistry(provider: self)
        let lifecycle:JKLifecycle = getLifecycle()
        let _ = lifecycle.addObserve {[weak self] source, event in
            if event == .ON_STOP {
//                取消第一响应者，不再响应输入事件
                self?.resignFirstResponder()
            }
        }
        mLifecycleRegistry?.handleLifecycleEvent(event: .ON_CREATE)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        mLifecycleRegistry?.handleLifecycleEvent(event: .ON_START)
    }
    
    open override func viewWillAppear() {
        super.viewWillAppear()
        mLifecycleRegistry?.handleLifecycleEvent(event: .ON_RESUME)
    }
    
    
    open override func viewWillDisappear() {
        super.viewWillDisappear()
        mLifecycleRegistry?.handleLifecycleEvent(event: .ON_PAUSE)
    }
    
    open override func transition(from fromViewController: NSViewController, to toViewController: NSViewController, options: NSViewController.TransitionOptions = [], completionHandler completion: (() -> Void)? = nil) {
        super.transition(from: fromViewController, to: toViewController, options: options, completionHandler: completion)
        if fromViewController == self {
            mLifecycleRegistry?.handleLifecycleEvent(event: .ON_STOP)
        }
    }
  
    open override func dismiss(_ viewController: NSViewController) {
        super.dismiss(viewController)
        self.mLifecycleRegistry?.handleLifecycleEvent(event: .ON_STOP)
    }
    
    deinit {
        mLifecycleRegistry?.handleLifecycleEvent(event: .ON_DESTROY)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//    MARK: - - JKLifecycleOwner - -
    public func getLifecycle() -> JKLifecycle {
        return mLifecycleRegistry!
    }
    
}
