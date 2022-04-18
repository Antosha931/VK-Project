//
//  AsyncOperation.swift
//  VK Project
//
//  Created by Антон Титов on 18.04.2022.
//

import Foundation

class AsyncOperation: Operation {
    
    enum State: String { // энам состояния для асинхронных операций
        case ready, executing, finished
        
        var keyPath: String {
            return "is" + rawValue.capitalized // с большой буквы
        }
    }
    
    var state = State.ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        // по ключу будем отправлять уведомления, что наше состояние переопределилось и с какое на какое поменялось
        didSet {
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }
    
    
    override var isAsynchronous: Bool { // флаг нужно переопределить
        return true // асинхронная операция
    }
    
    override var isReady: Bool {
        return super.isReady && state == .ready // и супер должен быть реди, и наше состояние тоже должно быть реди
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    
    override var isFinished: Bool {
        return state == .finished
    }
    
    override func start() {
        if isCancelled { // если отменена
            state = .finished // то завершена
        } else {
            main()
            state = .executing // то выполняется
        }
    }
    
    override func cancel() {
        super.cancel()
        state = .finished
    }
}
