//
//  SynthesisApiMock.swift
//  ChatDemo
//
//  Created by Marco Aurélio Bigélli Cardoso on 02/08/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation
@testable import ChatDemo

class SynthesisApiMock: SynthesisApi {
    var startSynthesisBlock: ((Void) -> Void)?
    var startSpeechBlock: ((Void) -> Void)?
    var successBlock: ((Void) -> Void)?
    var failureBlock: ((String) -> Void)?
    
    func synthesize(text: String,
                    speechStart:  ((Void) -> Void)?,
                    success: ((Void) -> Void)?,
                    failure: ((String) -> Void)?) {
        
        self.startSpeechBlock = speechStart
        self.successBlock = success
        self.failureBlock = failure
    }
    
    func cancel() {
        
    }
}
