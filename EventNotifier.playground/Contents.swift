
import Foundation

/// `EventNotifier` lets you easily create a "event notifier" for a given protocol or class.
public final class EventNotifier<T> {
    
    /// The listeners hash table.
    private let listeners = NSHashTable<AnyObject>.weakObjects()
    
    /// Use the property to check if no listeners are contained there.
    ///
    /// - Returns: `true` if there are no listeners at all, `false` if there is at least one.
    public var isEmpty: Bool {
        
        return listeners.allObjects.count == 0
    }
    
    /// Use this method to add a listener.
    ///
    /// - Parameter listener: The listener to be added.
    public func addListener(_ listener: T) {
        
        listeners.add(listener as AnyObject)
    }
    
    /// Use this method to remove a previously-added listener.
    ///
    /// - Parameter listener: The listener to be removed.
    public func removeListener(_ listener: T) {
        
        listeners.remove(listener as AnyObject)
    }
    
    /// Use this method to invoke a closure on each listener.
    ///
    /// - Parameter invocation: The closure to be invoked on each listener.
    public func invoke(_ invocation: (T) -> Void) {
        
        for listener in listeners.allObjects {
            
            invocation(listener as! T) // swiftlint:disable:this force_cast
        }
    }
    
    /// Use this method to determine if the multicast listener contains a given listener.
    ///
    /// - Parameter listener: The given listener to check if it's contained
    /// - Returns: `true` if the listener is found or `false` otherwise
    public func containsListener(_ listener: T) -> Bool {
        
        return listeners.contains(listener as AnyObject)
    }
}

// WORKING EXAMPLE

protocol Foo {
    func bar()
}

struct Example: Foo {
    func bar() {
        print("bar")
    }
}

let notifier = EventNotifier<Foo>()
let example = Example()
notifier.addListener(example)

notifier.invoke { (obj) in
    obj.bar()
}

print(notifier.isEmpty)
