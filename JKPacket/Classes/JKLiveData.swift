//
//  JKLiveData.swift
//  JKPacket
//
//  Created by JackLee on 2022/3/23.
//

import Foundation
import RxSwift

internal let liveDataLock:NSRecursiveLock = NSRecursiveLock()

public class JKLiveData<U:JKObserver> {
    private var mObservers = [UUID:JKObserverWrapper<U>]()
    var mActiveCount:Int = 0
    private var mVersion:Int = 0
    private var mDispatchingValue = false
    private var mDispatchInvalidated = false
    private var mData:U.T?
    private var mExtra:Any?
    public var value:U.T? {
        set {
            invokeChange(newValue: newValue, extra: nil)
        }
        get {
            return mData
        }
    }
    public init() {
        
    }
    
    internal func invokeChange(newValue:U.T?, extra:Any?) {
        defer {
            liveDataLock.unlock()
        }
        liveDataLock.lock()
        mVersion += 1
        mData = newValue
        mExtra = extra
        dispatchingValue(wrapper: nil, extra: extra)
    }
    
    private func considerNotify(observer:JKObserverWrapper<U>, extra:Any? = nil) {
        
        guard observer.mActive == true else {
            observer.mObserver.markHasPendingData(mData, extra: extra)
            return
        }
        
        guard observer.shouldBeActive == true else {
            observer.activeStateChanged(active:false, liveData: self)
            observer.mObserver.markHasPendingData(mData, extra: extra)
            return
        }
        
        guard observer.mLastVersion < mVersion else {
            return
        }
        
        observer.mLastVersion = mVersion
        observer.mObserver.onChanged(t: mData, extra: extra)
    }
    
    func dispatchingValue(wrapper:JKObserverWrapper<U>?, extra:Any? = nil) {
        defer {
            liveDataLock.unlock()
        }
        liveDataLock.lock()
        guard mDispatchingValue == false else  {
            mDispatchInvalidated = true
            return
        }
        mDispatchingValue = true
        repeat {
            mDispatchInvalidated = false
            if wrapper != nil {
                considerNotify(observer: wrapper!, extra: extra)
            } else {
                for (_,wrapper) in mObservers {
                    considerNotify(observer: wrapper, extra: extra)
                    if mDispatchInvalidated == true {
                        break
                    }
                }
            }
        } while mDispatchInvalidated == true
        mDispatchingValue = false
    }
    
    func observe(owner:JKLifecycleOwner, observer:U) {
        #if DEBUG
        assert(observer as? JKLiveData == nil, "observer can not be JKLiveData instance")
        #endif
        defer {
            liveDataLock.unlock()
        }
        liveDataLock.lock()
        guard owner.getLifecycle().getCurrentState() != .DESTROYED else {
            return
        }
        
        if let wrapper = mObservers[observer.uniqueId], wrapper.isAttachedTo(owner) == false {
            fatalError("Cannot add the same observer"
                       + " with different lifecycles")
        }
        guard mObservers[observer.uniqueId] == nil else {
            return
        }
        let wrapper = JKLifecycleBoundObserver(owner: owner, observer: observer)
        mObservers[observer.uniqueId] = wrapper
        wrapper.stateChangedBlock = {[weak self] ( source: JKLifecycleOwner,  event: JKLifecycle.Event) in
             let state = getState(with: event, currentState: owner.getLifecycle().getCurrentState())
            let active = JKLifecycleBoundObserver<U>.isActiveState(state: state)
             wrapper.activeStateChanged(active:active, liveData: self)
        }
        let isActive = JKLifecycleBoundObserver<U>.isActiveState(state: owner.getLifecycle().getCurrentState())
        wrapper.mActive = isActive
        owner.getLifecycle().addObserver(wrapper)
    }
    
    func observeForever(observer:U) {
        #if DEBUG
        assert(observer as? JKLiveData == nil, "observer can not be JKLiveData instance")
        #endif
        defer {
            liveDataLock.unlock()
        }
        liveDataLock.lock()
        if let wrapper = mObservers[observer.uniqueId], wrapper as? JKLifecycleBoundObserver != nil  {
            fatalError("Cannot add the same observer"
                       + " with different lifecycles")
        }
        guard mObservers[observer.uniqueId] == nil else {
            return
        }
        let wrapper = JKAlwaysActiveObserver(observer: observer)
        mObservers[wrapper.uniqueId] = wrapper
        wrapper.activeStateChanged(active:true, liveData: self)
    }
    
    func removeObserver(_ observer:U) {
        defer {
            liveDataLock.unlock()
        }
        liveDataLock.lock()
        if let wrapper = mObservers[observer.uniqueId] {
            wrapper.detachObserver()
            wrapper.activeStateChanged(active:false, liveData:self)
        }
    }
    
    func removeObservers(owner:JKLifecycleOwner) {
        defer {
            liveDataLock.unlock()
        }
        liveDataLock.lock()
        for (_, wrapper) in mObservers {
            if wrapper.isAttachedTo(owner) == true {
                wrapper.detachObserver()
                wrapper.activeStateChanged(active:false, liveData:self)
            }
        }
    }
    
    internal func onActive() {
        
    }
    
    internal func onInactive() {
        
    }
    
    func hasObservers() -> Bool {
        return mObservers.count > 0
    }
    
    internal func getExtra() ->Any? {
        return mExtra
    }
    
    
}

//public extension JKLiveData {
//    func observe(owner:JKLifecycleOwner,onSubject:((_ subject:Observable<U.T?>)->Observable<U.T?>)? = nil, block: @escaping ((_ value:U.T?)->Void)) {
//        let observer = JKDefaultObserver<U.T>()
//         observer.observe(onSubject: onSubject, block: block)
//        observe(owner: owner, observer: observer as! U)
//    }
//    
//    func observeForever(observer:U,onSubject:((_ subject:Observable<U.T?>)->Observable<U.T?>)? = nil, block: @escaping ((_ value:U.T?)->Void)) -> U {
//        let observer = JKDefaultObserver<U.T>()
//         observer.observe(onSubject: onSubject, block: block)
//        observeForever(observer: observer as! U)
//        return observer as! U
//    }
//        
//}
