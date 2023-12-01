//
//  JKLifecycleRegistry.swift
//  JKPacket
//
//  Created by JackLee on 2022/4/3.
//

import Foundation

fileprivate let lifecycleRegistryLock:NSRecursiveLock = NSRecursiveLock()

public class JKLifecycleRegistry:JKLifecycle {
    private var mState:State = .NONE
    private var mEvent:Event = .ON_ANY
    private var mObserverList = [JKObserverWithState]()
    private var mAddingObserverCounter = 0
    private weak var mLifecycleOwner:JKLifecycleOwner?
    private var mHandlingEvent = false
    private var mNewEventOccurred = false
    
     init(provider:JKLifecycleOwner) {
         mLifecycleOwner = provider
         mState = .CREATED
         mEvent = .ON_CREATE
    }
    
    func handleLifecycleEvent(event:JKLifecycle.Event) {
        let state = getState(with: event,currentState: mState)
        moveToState(state,event: event)
    }
    
    public override func getCurrentState() -> JKLifecycle.State {
        return mState
    }
    
    public override func addObserver(_ observer: any JKLifecycleObserver) {
        defer {
            lifecycleRegistryLock.unlock()
        }
        lifecycleRegistryLock.lock()
        
        let initialState:State = mState
        guard mObserverList.contains(where: { tmpObserverWithState in
            return tmpObserverWithState.mLifecycleObserver.hashValue == observer.hashValue
        }) == false else {
         return
        }
        let statefulObserver = JKObserverWithState(observer: observer, initialState: initialState)
        mObserverList.append(statefulObserver)
        guard mLifecycleOwner != nil else {
            return
        }
        let isReentrance:Bool = mAddingObserverCounter != 0 || mHandlingEvent == true
        mAddingObserverCounter += 1
        if isReentrance == false {
            sync()
        }
        mAddingObserverCounter -= 1
    }
    
    public override func removeObserver(_ observer:any JKLifecycleObserver) {
        defer {
            lifecycleRegistryLock.unlock()
        }
        lifecycleRegistryLock.lock()
        mObserverList.removeAll {tmpObserverWithState in
            return tmpObserverWithState.mLifecycleObserver.hashValue == observer.hashValue
        }
    }
    
    public func getObserverCount() ->Int {
        return mObserverList.count
    }
    
    private func moveToState(_ state:State, event:JKLifecycle.Event) {
        defer {
            lifecycleRegistryLock.unlock()
        }
        lifecycleRegistryLock.lock()
        guard mState != state  else {
            return
        }
        mState = state
        mEvent = event
        if mHandlingEvent == true || mAddingObserverCounter != 0 {
            mNewEventOccurred = true
            return
        }
        mHandlingEvent = true
        sync()
        mHandlingEvent = false
    }
    
    
    private func sync() {
        guard mLifecycleOwner != nil else {
            fatalError("LifecycleOwner of this LifecycleRegistry is already"
                       + "garbage collected. It is too late to change lifecycle state.")
        }
        while isSynced() == false {
            mNewEventOccurred = false
            for tmpObserverWithState in mObserverList {
                if tmpObserverWithState.mState != mState {
                    tmpObserverWithState.dispatchEvent(owner: mLifecycleOwner!, event: mEvent, state: mState)
                }
                
            }
        }
        mNewEventOccurred = false
    }
    
    private func isSynced() -> Bool {
        defer {
            lifecycleRegistryLock.unlock()
        }
        lifecycleRegistryLock.lock()
        if mObserverList.count == 0 {
            return true
        }
        let eldestState = mObserverList.first?.mState
        let newestState = mObserverList.last?.mState
        return eldestState == newestState && mState == newestState
    }
    
    private func removeAllObservers() {
        mObserverList.removeAll()
    }
    
    private class JKObserverWithState {
        
        var mState:State = .NONE
        var mLifecycleObserver:any JKLifecycleObserver
        let uniqueId:UUID = UUID()
        init(observer:any JKLifecycleObserver, initialState:State) {
            mLifecycleObserver = observer
            mState = initialState
        }
       
        func dispatchEvent(owner:JKLifecycleOwner, event:JKLifecycle.Event, state:JKLifecycle.State) {
           mLifecycleObserver.onStateChanged(source: owner, event: event)
           mState = state
       }
        
    }

}




