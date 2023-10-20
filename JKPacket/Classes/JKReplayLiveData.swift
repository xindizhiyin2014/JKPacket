//
//  JKReplayLiveData.swift
//  JKPacket
//
//  Created by jack on 2023/10/19.
//

import Foundation
import RxSwift

final public class JKReplayLiveData<T>:JKLiveData<JKReplayObserver<T>> {
    
    /// observe a livedata with buffer when the lifecycle is inative,it hold the receive data,when the lifecycle become avtive,it fire the block with the pending receive datas
    /// - Parameters:
    ///   - owner: the lifecycle owner
    ///   - bufferSize: the receive data count need to hold,when the lifecycle is inactive ,defalut is 1,when set zero,the bufferSize is no limit
    ///   - onSubject: rxswit block with paramter of Observable
    ///   - block: the block which need the developer to handle things
    public func observe(owner:JKLifecycleOwner, bufferSize:UInt = 1, onSubject:((_ subject:Observable<T?>)->Observable<T?>)? = nil, block: @escaping ((_ value:T?)->Void)) {
         let observer = JKReplayObserver<T>(bufferSize: bufferSize)
         observer.observe(onSubject: onSubject, block: block)
         observe(owner: owner, observer: observer as! JKReplayObserver)
    }
    
    /// observe a livedata with buffer when the lifecycle is inative,it hold the receive data,when the lifecycle become avtive,it fire the block with the pending receive datas
    /// - Parameters:
    ///   - owner: the lifecycle owner
    ///   - bufferSize: the receive data count need to hold,when the lifecycle is inactive ,defalut is 1,when set zero,the bufferSize is no limit
    ///   - onSubject: rxswit block with paramter of Observable
    ///   - block: the block which need the developer to handle things
    public func observeOnMainThread(owner:JKLifecycleOwner, bufferSize:UInt = 1, onSubject:((_ subject:Observable<T?>)->Observable<T?>)? = nil, block: @escaping ((_ value:T?)->Void)) {
         let observer = JKReplayObserver<T>(bufferSize: bufferSize)
         var  _onSubject:((_ subject:Observable<T?>)->Observable<T?>) = { subject in
               if onSubject != nil {
                   return onSubject!(subject).observeOn(MainScheduler.instance)
               } else {
                   return subject.observeOn(MainScheduler.instance)
               }
          }
         observer.observe(onSubject: _onSubject, block: block)
         observe(owner: owner, observer: observer as! JKReplayObserver)
     }
    
   
    
    
}
