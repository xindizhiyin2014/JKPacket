//
//  JKProcessLifecycleOwner.swift
//  JKPacket
//
//  Created by jack on 2023/11/22.
//

import Foundation
public class JKProcessLifecycleOwner : NSObject, JKLifecycleOwner {
    final private var mLifecycleRegistry:JKLifecycleRegistry?

    public func getLifecycle() -> JKLifecycle {
        return mLifecycleRegistry!
    }
    
    public static let shared = JKProcessLifecycleOwner()
    
    override init () {
        super.init()
        mLifecycleRegistry = JKLifecycleRegistry(provider: self)
        mLifecycleRegistry?.handleLifecycleEvent(event: .ON_CREATE)
    }
    
    public static func setup() {
        let instance = JKProcessLifecycleOwner.shared
        NotificationCenter.default.addObserver(instance, selector: #selector(applicationBecomeActive(_ :)), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(instance, selector: #selector(applicationDidEnterBackground(_ :)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(instance, selector: #selector(applicationWillTerminate(_ :)), name: UIApplication.willTerminateNotification, object: nil)
        JKProcessLifecycleOwner.shared.mLifecycleRegistry?.handleLifecycleEvent(event: .ON_START)
    }
    
    
    @objc private func applicationBecomeActive(_ notification:Notification) {
        mLifecycleRegistry?.handleLifecycleEvent(event: .ON_RESUME)
    }
    
    @objc private func applicationDidEnterBackground(_ notification:Notification) {
        mLifecycleRegistry?.handleLifecycleEvent(event: .ON_PAUSE)
    }
    
    @objc private func applicationWillTerminate(_ notification:Notification) {
        mLifecycleRegistry?.handleLifecycleEvent(event: .ON_DESTROY)
    }
    
    
}
