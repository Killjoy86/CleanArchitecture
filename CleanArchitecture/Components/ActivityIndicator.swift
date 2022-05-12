//
//  ActivityIndicator.swift
//  TestArch
//
//  Created by Roman Syrota on 04.05.2022.
//

import Foundation
import Combine

public class ActivityIndicator: Publisher {
    
    public typealias Output = Bool
    public typealias Failure = Never
    
    private let lock = NSRecursiveLock()
    private let relay = CurrentValueSubject<Int, Never>(0)
    private let loading: AnyPublisher<Bool, Never>
    
    public init() {
        loading = relay
            .map { $0 > 0 }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    public func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Bool == S.Input {
        loading.receive(subscriber: subscriber)
    }
    
    fileprivate func trackPublisherActivity<Source: Publisher>(of source: Source) -> AnyPublisher<Source.Output, Source.Failure> {
        increment()
        return ActivityToken(
            source: source.eraseToAnyPublisher(),
            cancelAction: decrement
        )
        .eraseToAnyPublisher()
    }
    
    private func increment() {
        lock.lock()
        relay.send(relay.value + 1)
        lock.unlock()
    }

    private func decrement() {
        lock.lock()
        relay.send(relay.value - 1)
        lock.unlock()
    }
}

private class ActivityToken<O, F> : Publisher, Cancellable where F : Error {

    typealias Output = O
    typealias Failure = F
    
    private let source: AnyPublisher<O, F>
    private let cancelable: AnyCancellable

    init(source: AnyPublisher<O, F>, cancelAction: @escaping () -> Void) {
        self.source = source
        self.cancelable = AnyCancellable(cancelAction)
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, F == S.Failure, O == S.Input {
        source.receive(subscriber: subscriber)
    }
    
    func cancel() {
        cancelable.cancel()
    }
    
    func eraseToAnyPublisher() -> AnyPublisher<O, F> {
        return source
    }
}

extension Publisher {
    
    func trackActivity(_ indicator: ActivityIndicator) -> AnyPublisher<Output, Failure> {
        return indicator.trackPublisherActivity(of: self)
    }
}
