//
//  WatsonTests.swift
//  ChatDemo
//
//  Created by Marco Aurélio Bigélli Cardoso on 08/08/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import XCTest
@testable import ChatDemo

class WatsonTests: XCTestCase {
    
    var instance: Watson?
    var sr: SpeechRecognizerMock = SpeechRecognizerMock()
    var lc: LanguageClassifierMock = LanguageClassifierMock()
    var vs: VoiceSynthesizerMock = VoiceSynthesizerMock()
    
    var lastState: WatsonState = .idle
    var lastFailure: String = ""
    
    override func setUp() {
        super.setUp()
        instance = Watson(recognizer: sr, classifier: lc, synthesizer: vs)
        instance?.delegate = self
    }
    
    override func tearDown() {
        super.tearDown()
        sr.reset()
        lc.reset()
        vs.reset()
        lastState = .idle
        lastFailure = ""
    }
    
    func testNormalInteraction() {
        XCTAssertEqual(instance?.state, .idle)
        
        instance?.start()
        XCTAssertEqual(instance?.state, .listening)
        XCTAssertEqual(lastState, .listening)
        
        sr.success?("Foo")
        XCTAssertEqual(instance?.state, .classifying)
        XCTAssertEqual(lastState, .classifying)
        
        lc.success?("Bar")
        XCTAssertEqual(instance?.state, .synthesizing)
        XCTAssertEqual(lastState, .synthesizing)
        
        vs.speechStart?()
        XCTAssertEqual(instance?.state, .speaking)
        XCTAssertEqual(lastState, .speaking)
        
        vs.success?()
        XCTAssertEqual(instance?.state, .idle)
        XCTAssertEqual(lastState, .idle)
    }
    
    func testRecognitionStop() {
        instance?.start()
        instance?.stop()
        XCTAssertEqual(instance?.state, .idle)
        XCTAssertEqual(lastState, .idle)
        XCTAssertEqual(lastFailure, "")
    }
    
    func testRecognitionError() {
        instance?.start()
        sr.failure?("Foo error")
        XCTAssertEqual(instance?.state, .idle)
        XCTAssertEqual(lastState, .idle)
        XCTAssertEqual(lastFailure, "Foo error")
    }
    
    func testClassificationStop() {
        instance?.start()
        sr.success?("Foo")
        lc.success?("Bar")
        instance?.stop()
        XCTAssertEqual(instance?.state, .idle)
        XCTAssertEqual(lastState, .idle)
        XCTAssertEqual(lastFailure, "")
    }
    
    func testClassificationError() {
        instance?.start()
        sr.success?("Foo")
        lc.failure?("Foo error")
        XCTAssertEqual(instance?.state, .idle)
        XCTAssertEqual(lastState, .idle)
        XCTAssertEqual(lastFailure, "Foo error")
    }
    
    func testSynthesisStop() {
        instance?.start()
        sr.success?("Foo")
        lc.success?("Bar")
        instance?.stop()
        XCTAssertEqual(instance?.state, .idle)
        XCTAssertEqual(lastState, .idle)
        XCTAssertEqual(lastFailure, "")
    }
    
    func testSynthesisError() {
        instance?.start()
        sr.success?("Foo")
        lc.success?("Bar")
        vs.failure?("Foo error")
        XCTAssertEqual(instance?.state, .idle)
        XCTAssertEqual(lastState, .idle)
        XCTAssertEqual(lastFailure, "Foo error")
    }
    
    func testSpeechStop() {
        instance?.start()
        sr.success?("Foo")
        lc.success?("Bar")
        vs.speechStart?()
        instance?.stop()
        XCTAssertEqual(instance?.state, .idle)
        XCTAssertEqual(lastState, .idle)
        XCTAssertEqual(lastFailure, "")
    }
    
    func testSpeechError() {
        instance?.start()
        sr.success?("Foo")
        lc.success?("Bar")
        vs.speechStart?()
        vs.failure?("Foo error")
        XCTAssertEqual(instance?.state, .idle)
        XCTAssertEqual(lastState, .idle)
        XCTAssertEqual(lastFailure, "Foo error")
    }
    
    func testIdleStop() {
        instance?.start()
        sr.success?("Foo")
        lc.success?("Bar")
        vs.speechStart?()
        vs.success?()
        instance?.stop()
        XCTAssertEqual(instance?.state, .idle)
        XCTAssertEqual(lastState, .idle)
        XCTAssertEqual(lastFailure, "")
    }
}

extension WatsonTests: WatsonDelegate {
    func watson(_ watson: Watson, didChangeState newState: WatsonState) {
    }
    
    func watson(_ watson: Watson, didSendQuestion question: String) {
    }
    
    func watson(_ watson: Watson, didGetAnswer answer: String) {
    }
    
    func watson(_ watson: Watson, didFail reason: String) {
    }
}

// - MARK: Collaborator Mocks

class SpeechRecognizerMock: SpeechRecognizerInterface {
    var startCalls: Int = 0
    var cancelCalls: Int = 0
    var success: ((String) -> ())?
    var failure: ((String) -> ())?

    func startRecognition(success: @escaping (String) -> (), failure: @escaping (String) -> ()) {
        startCalls += 1
        self.success = success
        self.failure = failure
    }
    
    func cancel() {
        cancelCalls += 1
    }
    
    func reset() {
        startCalls = 0
        cancelCalls = 0
    }
}

class LanguageClassifierMock: LanguageClassifierInterface {
    var classifyCalls: Int = 0
    var cancelCalls: Int = 0
    var success: ((String) -> ())?
    var failure: ((String) -> ())?
    
    func classify(text: String,
                  success: @escaping (String) -> (),
                  failure: @escaping (String) -> ()) {
        classifyCalls += 1
        self.success = success
        self.failure = failure
    }
    
    func cancel() {
        cancelCalls += 1
    }
    
    func reset() {
        classifyCalls = 0
        cancelCalls = 0
    }
}

class VoiceSynthesizerMock: VoiceSynthesizerInterface {
    var synthesizeCalls: Int = 0
    var cancelCalls: Int = 0
    var speechStart: (() -> ())?
    var success: (() -> ())?
    var failure: ((String) -> ())?
    
    func synthesize(text: String,
                    speechStart: @escaping () -> (),
                    success: @escaping () -> (),
                    failure: @escaping (String) -> ()) {
        synthesizeCalls += 1
        self.speechStart = speechStart
        self.success = success
        self.failure = failure
    }
    
    func cancel() {
        cancelCalls += 1
    }
    
    func reset() {
        synthesizeCalls = 0
        cancelCalls = 0
    }
}
