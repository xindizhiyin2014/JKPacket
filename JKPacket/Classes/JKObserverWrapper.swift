//
//  JKObserverWrapper.swift
//  JKPacket
//
//  Created by jack on 2023/10/8.
//

import Foundation


public class JKObserverWrapper<U:JKObserver>:Hashable {
        
    public static func == (lhs: JKObserverWrapper, rhs: JKObserverWrapper) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    public var hashValue: Int {
        uniqueId.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        uniqueId.hash(into: &hasher)
    }
    
    public var mActive:Bool = false
    public var shouldBeActive:Bool = false
    public var mLastVersion:Int = 0
    public var mObserver:U
    public var uniqueId: UUID = UUID()
    internal var bufferSize:UInt = 1
    
    init(observer:U) {
        self.mObserver = observer
    }
    
    func getValue() -> U {
        return mObserver
    }
    
    func detachObserver() {
        
    }
    
    func isAttachedTo(_ owner:JKLifecycleOwner) ->Bool {
        return false
    }
    
    func activeStateChanged(active:Bool, liveData:JKLiveData<U>?) {
    }
   
    
}

public class JKLifecycleBoundObserver<U:JKObserver>:JKObserverWrapper<U>,JKLifecycleObserver {
    public typealias StateChangedBlock = (_ source: JKLifecycleOwner, _ event: JKLifecycle.Event) -> Void
    public var stateChangedBlock:StateChangedBlock?
    
    private weak var mOwner:JKLifecycleOwner?
    
    init(owner:JKLifecycleOwner,observer: U) {
        self.mOwner = owner
        super.init(observer: observer)
    }
    
   static func isActiveState(state:JKLifecycle.State) -> Bool
     {
         return state == .STARTED || state == .RESUMED
     }
    
    override func isAttachedTo(_ owner:JKLifecycleOwner) ->Bool {
        mOwner === owner
    }
    
    public override var shouldBeActive: Bool {
        set {}
        get {
            JKLifecycleBoundObserver.isActiveState(state: mOwner?.getLifecycle().getCurrentState() ?? .NONE)
        }
    }
    
    override func detachObserver() {
        mOwner?.getLifecycle().removeObserver(self)
    }
    
    override func activeStateChanged(active:Bool, liveData:JKLiveData<U>?) {
        defer {
            liveDataLock.unlock()
        }
        liveDataLock.lock()
        guard mActive != active else {
            return
        }
        guard let liveData = liveData else {
            return
        }
        mActive = active
        let wasInactive = liveData.mActiveCount == 0
         liveData.mActiveCount += mActive ? 1 : -1
        if wasInactive == true, mActive == true {
            liveData.onActive()
        }
        if liveData.mActiveCount == 0, mActive == false {
            liveData.onInactive()
        }
        if mActive == true {
            if mObserver.isHavePendingData() == true {
                liveData.dispatchingValue(wrapper: self, extra: liveData.getExtra())
                mObserver.markHasNoPendingData()
            }
            
        }
        
    }
    
    public func onStateChanged(source: JKLifecycleOwner, event: JKLifecycle.Event) {
        guard event != .ON_ANY else {
            return
        }
        stateChangedBlock?(source,event)
    }
    
}


public class JKAlwaysActiveObserver<U:JKObserver>:JKObserverWrapper<U> {
    
    public override var mActive: Bool {
        set {}
        get {
            return true
        }
    }
    public override var shouldBeActive: Bool {
        set {}
        get {
            return true
        }
    }
    
}
