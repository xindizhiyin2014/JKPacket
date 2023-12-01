//
//  JKLifecycle.swift
//  JKPacket
//
//  Created by JackLee on 2022/3/20.
//

import Foundation
public class JKLifecycle {
    
    public enum State:Int {
        case NONE
        case DESTROYED
        case CREATED
        case STARTED
        case RESUMED
        case PAUSED
        case STOPPED
    }
    
    public enum Event {
       case ON_ANY
       case ON_DESTROY
       case ON_CREATE
       case ON_START
       case ON_RESUME
       case ON_PAUSE
       case ON_STOP
       
     }
   
    public func addObserver(_ observer:any JKLifecycleObserver) {
        
    }
    
    public func removeObserver(_ observer:any JKLifecycleObserver) {
        
    }
    
    public func getCurrentState() -> JKLifecycle.State {
        return .NONE
    }
    
}


internal func getState(with event:JKLifecycle.Event, currentState:JKLifecycle.State) -> JKLifecycle.State{
   switch event {
   case .ON_ANY:
       return .NONE
   case .ON_CREATE:
       return .CREATED
   case .ON_START:
       return .STARTED
   case .ON_RESUME:
       if currentState == .STARTED {
           return .STARTED
       }
       return  .RESUMED
   case .ON_PAUSE:
       return .PAUSED
   case .ON_STOP:
       return .STOPPED
   case .ON_DESTROY:
       return .DESTROYED
   }
   
}


public extension JKLifecycle {
    
    func addObserve(_ observer: any JKLifecycleObserver = JKDefaultLifecycleObserver(),
                    stateChange:@escaping ((_ source: JKLifecycleOwner, _ event: JKLifecycle.Event) -> Void)) -> any JKLifecycleObserver {
        var currentObserver = observer
        currentObserver.stateChangedBlock = stateChange
        self.addObserver(currentObserver)
        return currentObserver
    }
}

