//
//  JKDefalutLiveData.swift
//  JKPacket
//
//  Created by jack on 2023/10/18.
//

import Foundation
import RxSwift

final public class JKDefaultLiveData<T>:JKLiveData<JKDefaultObserver<T>> {
    
    /// observe a livedata,when the lifecycle is inactive,it hold the receive data, when the lifecycle become active,it fire the newest pending data
    /// - Parameters:
    ///   - owner: the lifecycle owner
    ///   - onSubject: rxswit block with paramter of Observable
    ///   - block: the block which need the developer to handle things
    public func observe(owner:JKLifecycleOwner, onSubject:((_ subject:Observable<T?>)->Observable<T?>)? = nil, block: @escaping ((_ value:T?)->Void)) {
         let observer = JKDefaultObserver<T>()
         observer.observe(onSubject: onSubject, block: block)
         observe(owner: owner, observer: observer as! JKDefaultObserver)
    }
    
    /// observe a livedata ignore lifecycle
    /// - Parameters:
    ///   - observer: forever observer
    ///   - onSubject: rxswit block with paramter of Observable
    ///   - block: the block which need the developer to handle things
    /// - Returns: the observer in use, the developer need to hold it,when they need remov it
   public func observeForever(observer:JKDefaultObserver<T>, onSubject:((_ subject:Observable<T?>)->Observable<T?>)? = nil, block: @escaping ((_ value:T?)->Void)) -> JKDefaultObserver<T> {
        let observer = JKDefaultObserver<T>()
         observer.observe(onSubject: onSubject, block: block)
        observeForever(observer: observer as! JKDefaultObserver)
        return observer as! JKDefaultObserver
    }
    
    /// observe a livedata on main thread,when the lifecycle is inactive,it hold the receive data, when the lifecycle become active,it fire the newest pending data
    /// - Parameters:
    ///   - owner: the lifecycle owner
    ///   - onSubject: rxswit block with paramter of Observable
    ///   - block: the block which need the developer to handle things
    public func observeOnMainThread(owner:JKLifecycleOwner, onSubject:((_ subject:Observable<T?>)->Observable<T?>)? = nil, block: @escaping ((_ value:T?)->Void)) {
         let observer = JKDefaultObserver<T>()
        let  _onSubject:((_ subject:Observable<T?>)->Observable<T?>) = { subject in
               if onSubject != nil {
                   return onSubject!(subject).observeOn(MainScheduler.instance)
               } else {
                   return subject.observeOn(MainScheduler.instance)
               }
          }
         observer.observe(onSubject: _onSubject, block: block)
         observe(owner: owner, observer: observer as! JKDefaultObserver)
     }
    
    /// observe a livedata ignore lifecycle on main thread
    /// - Parameters:
    ///   - observer: forever observer
    ///   - onSubject: rxswit block with paramter of Observable
    ///   - block: he block which need the developer to handle things
    /// - Returns: the observer in use, the developer need to hold it,when they need remov it
    public func observeForeverOnMainThread(observer:JKDefaultObserver<T>, onSubject:((_ subject:Observable<T?>)->Observable<T?>)? = nil, block: @escaping ((_ value:T?)->Void)) -> JKDefaultObserver<T> {
         
         let observer = JKDefaultObserver<T>()
        let  _onSubject:((_ subject:Observable<T?>)->Observable<T?>) = { subject in
             if onSubject != nil {
                 return onSubject!(subject).observeOn(MainScheduler.instance)
             } else {
                 return subject.observeOn(MainScheduler.instance)
             }
         }
         observer.observe(onSubject: _onSubject, block: block)
         observeForever(observer: observer as! JKDefaultObserver)
         return observer as! JKDefaultObserver
     }
    
    
}
