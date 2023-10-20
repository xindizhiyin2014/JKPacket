//
//  JKBaseViewController.swift
//  JKPacket
//
//  Created by JackLee on 2022/3/20.
//

import Foundation
open class JKLifeCycleViewController:UIViewController,JKLifecycleOwner
{
    final private var mLifecycleRegistry:JKLifecycleRegistry?
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        mLifecycleRegistry = JKLifecycleRegistry(provider: self)
        let lifecycle:JKLifecycle = getLifecycle()
        let observer:JKDefaultLifecycleObserver = JKDefaultLifecycleObserver()
        observer.stateChangedBlock = {(source:JKLifecycleOwner,event:JKLifecycle.Event) in
            if event == .ON_STOP {
//                取消第一响应者，不再响应输入事件
                self.resignFirstResponder()
            }
        }
        lifecycle.addObserver(observer)
        mLifecycleRegistry?.handleLifecycleEvent(event: .ON_CREATE)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        mLifecycleRegistry?.handleLifecycleEvent(event: .ON_START)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mLifecycleRegistry?.handleLifecycleEvent(event: .ON_RESUME)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mLifecycleRegistry?.handleLifecycleEvent(event: .ON_PAUSE)
    }
    
    open override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        if parent == nil {
            mLifecycleRegistry?.handleLifecycleEvent(event: .ON_STOP)
        }
    }
    
    open override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag) {
            self.mLifecycleRegistry?.handleLifecycleEvent(event: .ON_STOP)
            completion?()
        }
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
