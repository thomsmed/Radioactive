import XCTest
@testable import Radioactive

final class RadioactiveTests: XCTestCase {
    func testCanCreateMutableEmitter() {
        let value = "Hello, World!"
        
        let mutableEmitter = MutableEmitter(value)
        
        XCTAssertEqual(mutableEmitter.value, value)
    }
    
    func testCanGetEmitterFroMutableEmitter() {
        let value = "Hello, World!"
        let mutableEmitter = MutableEmitter(value)
        
        var emitter: Emitter<String>?
        emitter = mutableEmitter
        
        XCTAssertNotNil(emitter)
    }
    
    func testCanListenOnEmitter() {
        let value = "Hello, World!"
        let mutableEmitter = MutableEmitter(value)
        
        var emittedValue: String?
        _ = mutableEmitter.listen({ emittedValue = $0 })
        
        XCTAssertEqual(emittedValue, value)
    }
    
    func testCanStopListeningOnEmitter() {
        let initialValue = "Hello, World!"
        let nextValue = "Hello, Universe!"
        let mutableEmitter = MutableEmitter(initialValue)
        
        var emittedValue: String?
        let handle = mutableEmitter.listen({ emittedValue = $0 })

        XCTAssertEqual(emittedValue, initialValue)

        handle.stop()
        
        XCTAssertNotEqual(emittedValue, nextValue)
    }
    
    func testMultipleCanListenOnEmitter() {
        let initialValue = "Hello, World!"
        let nextValue = "Hello, Universe!"
        let mutableEmitter = MutableEmitter(initialValue)
        
        var emittedValue1: String?
        _ = mutableEmitter.listen({ emittedValue1 = $0 })
        var emittedValue2: String?
        _ = mutableEmitter.listen({ emittedValue2 = $0 })
        var emittedValue3: String?
        _ = mutableEmitter.listen({ emittedValue3 = $0 })
        
        mutableEmitter.value = nextValue
        
        XCTAssertEqual(emittedValue1, nextValue)
        XCTAssertEqual(emittedValue2, nextValue)
        XCTAssertEqual(emittedValue3, nextValue)
    }
    
    func testOthersCanListenOnEmitter() {
        let initialValue = "Hello, World!"
        let nextValue = "Hello, Universe!"
        let mutableEmitter = MutableEmitter(initialValue)
        
        var emittedValue1: String?
        _ = mutableEmitter.listen({ emittedValue1 = $0 })
        var emittedValue2: String?
        let handle2 = mutableEmitter.listen({ emittedValue2 = $0 })
        var emittedValue3: String?
        _ = mutableEmitter.listen({ emittedValue3 = $0 })
        
        handle2.stop()
        
        mutableEmitter.value = nextValue
        
        XCTAssertEqual(emittedValue1, nextValue)
        XCTAssertEqual(emittedValue2, initialValue)
        XCTAssertEqual(emittedValue3, nextValue)
    }

    static var allTests = [
        ("testCanCreateMutableEmitter", testCanCreateMutableEmitter),
        ("testCanGetEmitterFroMutableEmitter", testCanGetEmitterFroMutableEmitter),
        ("testCanListenOnEmitter", testCanListenOnEmitter),
        ("testCanStopListeningOnEmitter", testCanStopListeningOnEmitter),
        ("testMultipleCanListenOnEmitter", testMultipleCanListenOnEmitter),
        ("testOthersCanListenOnEmitter", testOthersCanListenOnEmitter)
    ]
}
