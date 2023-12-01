//
//  JKLiveArray.swift
//  JKPacket
//
//  Created by jack on 2023/11/10.
//

import Foundation
import RxSwift

public enum JKArrayPartialChangeType {
    case `assign`  //赋值操作
    case append
    case insert
    case removeAt
    case removeWhere
    case removeAll
    case replace
}

public struct JKArrayPartialChange {
  public  let type:JKArrayPartialChangeType
  public  let indexs:[Int]?
    
  public init(type: JKArrayPartialChangeType, indexs: [Int]?) {
        self.type = type
        self.indexs = indexs
  }
}

public class JKLiveArray<T>: JKLiveData<JKArrayObserver<[T]>> {
    
    public func append(_ element:T) {
        defer {
            liveDataLock.unlock()
        }
        liveDataLock.lock()
        let index = self.value?.count ?? 0
        var newValue:[T]?
        if self.value == nil {
            newValue = [element]
        } else {
            newValue = self.value
            newValue?.append(element)
        }
        let extra = JKArrayPartialChange(type: .append, indexs: [index])
        invokeChange(newValue: newValue, extra: extra)
    }
    
    public func insert(element: T, at index:Int) {
        defer {
            liveDataLock.unlock()
        }
        liveDataLock.lock()
        var newValue:[T]?
        if self.value == nil {
            newValue = [T]()
            newValue?.insert(element, at: index)
        } else {
            newValue = self.value
            newValue?.insert(element, at: index)
        }
        let extra = JKArrayPartialChange(type: .insert, indexs: [index])
        invokeChange(newValue: newValue, extra: extra)
    }
    
    public func remove(at index:Int) {
        defer {
            liveDataLock.unlock()
        }
        liveDataLock.lock()
        guard var newValue = self.value else {
            return
        }
        newValue.remove(at: index)
        let extra = JKArrayPartialChange(type: .removeAt, indexs: [index])
        invokeChange(newValue: newValue, extra: extra)
        
    }
    
    public func removeAll(where shouldRemoved:(T) -> Bool) {
        defer {
            liveDataLock.unlock()
        }
        liveDataLock.lock()
        guard var newValue = self.value else {
            return
        }
        var indexs = [Int]()
        var index = 0
        newValue.removeAll(where: { e in
            let result = shouldRemoved(e)
            if result == true {
                let currentIndex = index
                indexs.append(currentIndex)
            }
            index += 1
            return result
        })
        if indexs.count > 0 {
            let extra = JKArrayPartialChange(type: .removeWhere, indexs: indexs)
            invokeChange(newValue: newValue, extra: extra)
        }
    }
    
    public func removeAll(keepingCapacity keepCapacity: Bool = false) {
        defer {
            liveDataLock.unlock()
        }
        liveDataLock.lock()
        guard var newValue = self.value else {
            return
        }
        let oldCount = newValue.count
        newValue.removeAll()
        let newCount = newValue.count
        if newCount < oldCount {
            let extra = JKArrayPartialChange(type: .removeAll, indexs: nil)
            invokeChange(newValue: newValue, extra: extra)
        }

    }
    
    public func replace(element:T, at index:Int) {
        defer {
            liveDataLock.unlock()
        }
        liveDataLock.lock()
        var newValue:[T]?
        if self.value == nil {
            newValue = [T]()
        }else {
            newValue = self.value
        }
        newValue?.replaceSubrange(index ... index, with: [element])
        let extra = JKArrayPartialChange(type: .replace, indexs: [index])
        invokeChange(newValue: newValue, extra: extra)
    }
    
    public subscript(index: Int) -> T?{
        set {
            if newValue != nil {
                replace(element: newValue!, at: index)
            }
        }
        get {
            return self.value?[index]
        }
    }
    
    
    public var count: Int {
        defer {
            liveDataLock.unlock()
        }
        liveDataLock.lock()
       return self.value?.count ?? 0
    }
    
    public var isEmpty: Bool {
        defer {
            liveDataLock.unlock()
        }
        liveDataLock.lock()
       return self.value?.isEmpty ?? true
    }
    
}

public extension JKLiveArray {
    
    /// observe a livedata,when the lifecycle is inactive,it hold the receive data, when the lifecycle become active,it fire the newest pending data
    /// - Parameters:
    ///   - owner: the lifecycle owner
    ///   - onSubject: rxswit block with paramter of Observable
    ///   - block: the block which need the developer to handle things
    func observe(owner:JKLifecycleOwner, onSubject:((_ subject:Observable<(list: [T]?, change: JKArrayPartialChange?)>)->Observable<(list: [T]?, change: JKArrayPartialChange?)>)? = nil, block: @escaping ((_ value:(list: [T]?, change: JKArrayPartialChange?))->Void)) {
         let observer = JKArrayObserver<[T]>()
         observer.observe(onSubject: onSubject, block: block)
         observe(owner: owner, observer: observer as! JKArrayObserver)
    }
    
    /// observe a livedata ignore lifecycle
    /// - Parameters:
    ///   - observer: forever observer
    ///   - onSubject: rxswit block with paramter of Observable
    ///   - block: the block which need the developer to handle things
    /// - Returns: the observer in use, the developer need to hold it,when they need remov it
     func observeForever(observer:JKArrayObserver<[T]>, onSubject:((_ subject:Observable<(list: [T]?, change: JKArrayPartialChange?)>)->Observable<(list: [T]?, change: JKArrayPartialChange?)>)? = nil, block: @escaping ((_ value:(list: [T]?, change: JKArrayPartialChange?))->Void)) -> JKArrayObserver<[T]> {
        let observer = JKArrayObserver<[T]>()
         observer.observe(onSubject: onSubject, block: block)
        observeForever(observer: observer as! JKArrayObserver)
        return observer as! JKArrayObserver
    }
    
    /// observe a livedata on main thread,when the lifecycle is inactive,it hold the receive data, when the lifecycle become active,it fire the newest pending data
    /// - Parameters:
    ///   - owner: the lifecycle owner
    ///   - onSubject: rxswit block with paramter of Observable
    ///   - block: the block which need the developer to handle things
     func observeOnMainThread(owner:JKLifecycleOwner, onSubject:((_ subject:Observable<(list: [T]?, change: JKArrayPartialChange?)>)->Observable<(list: [T]?, change: JKArrayPartialChange?)>)? = nil, block: @escaping ((_ value:(list: [T]?, change: JKArrayPartialChange?))->Void)) {
         let observer = JKArrayObserver<[T]>()
        let  _onSubject:((_ subject:Observable<(list: [T]?, change: JKArrayPartialChange?)>)->Observable<(list: [T]?, change: JKArrayPartialChange?)>) = { subject in
               if onSubject != nil {
                   return onSubject!(subject).observeOn(MainScheduler.instance)
               } else {
                   return subject.observeOn(MainScheduler.instance)
               }
          }
         observer.observe(onSubject: _onSubject, block: block)
         observe(owner: owner, observer: observer as! JKArrayObserver)
     }
    
    /// observe a livedata ignore lifecycle on main thread
    /// - Parameters:
    ///   - observer: forever observer
    ///   - onSubject: rxswit block with paramter of Observable
    ///   - block: the block which need the developer to handle things
    /// - Returns: the observer in use, the developer need to hold it,when they need remov it
     func observeForeverOnMainThread(observer:JKArrayObserver<[T]>, onSubject:((_ subject:Observable<(list: [T]?, change: JKArrayPartialChange?)>)->Observable<(list: [T]?, change: JKArrayPartialChange?)>)? = nil, block: @escaping ((_ value:(list: [T]?, change: JKArrayPartialChange?))->Void)) -> JKArrayObserver<[T]> {
         
         let observer = JKArrayObserver<[T]>()
        let  _onSubject:((_ subject:Observable<(list: [T]?, change: JKArrayPartialChange?)>)->Observable<(list: [T]?, change: JKArrayPartialChange?)>) = { subject in
             if onSubject != nil {
                 return onSubject!(subject).observeOn(MainScheduler.instance)
             } else {
                 return subject.observeOn(MainScheduler.instance)
             }
         }
         observer.observe(onSubject: _onSubject, block: block)
         observeForever(observer: observer as! JKArrayObserver)
         return observer as! JKArrayObserver
     }
}

