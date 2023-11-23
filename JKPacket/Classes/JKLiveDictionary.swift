//
//  JKLiveDictionary.swift
//  JKPacket
//
//  Created by jack on 2023/11/10.
//

import Foundation
import RxSwift

public enum JKDictionaryPartialChangeType {
    case `assign`  //赋值操作
    case insert
    case remove
    case removeAll
    case replace
}

public struct JKDictionaryPartialChange<Key> where Key : Hashable  {
    public let type:JKDictionaryPartialChangeType
    public let keys:[Key]?
    public init(type: JKDictionaryPartialChangeType, keys: [Key]?) {
        self.type = type
        self.keys = keys
    }
}


public class JKLiveDictionary<Key,Value> : JKLiveData<JKDictionaryObserver<[Key : Value], Key>> where Key : Hashable{
    public func updateValue(_ value: Value, forKey key: Key) -> Value? {
        defer {
            liveDataLock.unlock()
        }
        liveDataLock.lock()
        var newValue:[Key:Value]?
        if self.value == nil {
            newValue = [Key:Value]()
        } else {
            newValue = self.value
        }
        var type:JKDictionaryPartialChangeType = .replace
        if self.value?[key] == nil {
            type = .insert
        }
        let result = newValue?.updateValue(value,forKey:key)
        invokeChange(newValue: newValue, extra: JKDictionaryPartialChange(type: type, keys: [key]))
        return result
    }
    
    public func removeValue(forKey key: Key) -> Value? {
        defer {
            liveDataLock.unlock()
        }
        liveDataLock.lock()
        var newValue:[Key:Value]?
        if self.value == nil {
            newValue = [Key:Value]()
        } else {
            newValue = self.value
        }
        let result = newValue?.removeValue(forKey:key)
        invokeChange(newValue: newValue, extra: JKDictionaryPartialChange(type: .remove, keys: [key]))
        return result
    }
    
    public func removeAll(keepingCapacity keepCapacity: Bool = false) {
        defer {
            liveDataLock.unlock()
        }
        liveDataLock.lock()
        var newValue:[Key:Value]?
        if self.value == nil {
            newValue = [Key:Value]()
        } else {
            newValue = self.value
        }
        newValue?.removeAll(keepingCapacity: keepCapacity)
        
        let keys = self.keys
        invokeChange(newValue: newValue, extra: JKDictionaryPartialChange(type: .removeAll, keys: keys))
    }
    
    public var keys: [Key]? {
        defer {
            liveDataLock.unlock()
        }
        liveDataLock.lock()
        guard self.value != nil else {
            return nil
        }
        var tmpKeys = [Key]()
        for (key, _) in self.value! {
            tmpKeys.append(key)
        }
        return tmpKeys
    }
    
    public var values: [Value]? {
        defer {
            liveDataLock.unlock()
        }
        liveDataLock.lock()
        guard self.value != nil else {
            return nil
        }
        var tmpValues = [Value]()
        for (_, value) in self.value! {
            tmpValues.append(value)
        }
        return tmpValues
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
    
    public subscript(key: Key) -> Value? {
        set {
            if newValue != nil {
              _ = updateValue(newValue!, forKey: key)
            } else {
              _ = removeValue(forKey: key)
            }
        }
        get {
            return self.value?[key]
        }
    }
    
}

public extension JKLiveDictionary {
    /// observe a livedata,when the lifecycle is inactive,it hold the receive data, when the lifecycle become active,it fire the newest pending data
    /// - Parameters:
    ///   - owner: the lifecycle owner
    ///   - onSubject: rxswit block with paramter of Observable
    ///   - block: the block which need the developer to handle things
    func observe(owner:JKLifecycleOwner, onSubject:((_ subject:Observable<(dic: [Key:Value]?, change: JKDictionaryPartialChange<Key>?)>)->Observable<(dic: [Key:Value]?, change: JKDictionaryPartialChange<Key>?)>)? = nil, block: @escaping ((_ value:(dic: [Key:Value]?, change: JKDictionaryPartialChange<Key>?))->Void)) {
         let observer = JKDictionaryObserver<[Key:Value], Key>()
         observer.observe(onSubject: onSubject, block: block)
         observe(owner: owner, observer: observer as! JKDictionaryObserver)
    }
    
    /// observe a livedata ignore lifecycle
    /// - Parameters:
    ///   - observer: forever observer
    ///   - onSubject: rxswit block with paramter of Observable
    ///   - block: the block which need the developer to handle things
    /// - Returns: the observer in use, the developer need to hold it,when they need remov it
    func observeForever(observer:JKDictionaryObserver<[Key:Value], Key>, onSubject:((_ subject:Observable<(dic: [Key:Value]?, change: JKDictionaryPartialChange<Key>?)>)->Observable<(dic: [Key:Value]?, change: JKDictionaryPartialChange<Key>?)>)? = nil, block: @escaping ((_ value:(dic: [Key:Value]?, change: JKDictionaryPartialChange<Key>?))->Void)) -> JKDictionaryObserver<[Key:Value], Key> {
        let observer = JKDictionaryObserver<[Key:Value], Key>()
         observer.observe(onSubject: onSubject, block: block)
        observeForever(observer: observer as! JKDictionaryObserver)
        return observer as! JKDictionaryObserver
    }
    
    /// observe a livedata on main thread,when the lifecycle is inactive,it hold the receive data, when the lifecycle become active,it fire the newest pending data
    /// - Parameters:
    ///   - owner: the lifecycle owner
    ///   - onSubject: rxswit block with paramter of Observable
    ///   - block: the block which need the developer to handle things
    func observeOnMainThread(owner:JKLifecycleOwner, onSubject:((_ subject:Observable<(dic: [Key:Value]?, change: JKDictionaryPartialChange<Key>?)>)->Observable<(dic: [Key:Value]?, change: JKDictionaryPartialChange<Key>?)>)? = nil, block: @escaping ((_ value:(dic: [Key:Value]?, change: JKDictionaryPartialChange<Key>?))->Void)) {
         let observer = JKDictionaryObserver<[Key:Value], Key>()
         let  _onSubject:((_ subject:Observable<(dic: [Key:Value]?, change: JKDictionaryPartialChange<Key>?)>)->Observable<(dic: [Key:Value]?, change: JKDictionaryPartialChange<Key>?)>) = { subject in
               if onSubject != nil {
                   return onSubject!(subject).observeOn(MainScheduler.instance)
               } else {
                   return subject.observeOn(MainScheduler.instance)
               }
          }
         observer.observe(onSubject: _onSubject, block: block)
         observe(owner: owner, observer: observer as! JKDictionaryObserver)
     }
    
    /// observe a livedata ignore lifecycle on main thread
    /// - Parameters:
    ///   - observer: forever observer
    ///   - onSubject: rxswit block with paramter of Observable
    ///   - block: the block which need the developer to handle things
    /// - Returns: the observer in use, the developer need to hold it,when they need remov it
    func observeForeverOnMainThread(observer:JKDictionaryObserver<[Key:Value], Key>, onSubject:((_ subject:Observable<(dic: [Key:Value]?, change: JKDictionaryPartialChange<Key>?)>)->Observable<(dic: [Key:Value]?, change: JKDictionaryPartialChange<Key>?)>)? = nil, block: @escaping ((_ value:(dic: [Key:Value]?, change: JKDictionaryPartialChange<Key>?))->Void)) -> JKDictionaryObserver<[Key:Value], Key> {
         
         let observer = JKDictionaryObserver<[Key:Value], Key>()
        let  _onSubject:((_ subject:Observable<(dic: [Key:Value]?, change: JKDictionaryPartialChange<Key>?)>)->Observable<(dic: [Key:Value]?, change: JKDictionaryPartialChange<Key>?)>) = { subject in
             if onSubject != nil {
                 return onSubject!(subject).observeOn(MainScheduler.instance)
             } else {
                 return subject.observeOn(MainScheduler.instance)
             }
         }
         observer.observe(onSubject: _onSubject, block: block)
         observeForever(observer: observer as! JKDictionaryObserver)
         return observer as! JKDictionaryObserver
     }
}
