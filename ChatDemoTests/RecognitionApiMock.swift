//
//  RecognitionApiMock.swift
//  ChatDemo
//
//  Created by Marco Aurélio Bigélli Cardoso on 01/08/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation
@testable import ChatDemo

class RecognitionApiMock: RecognitionApi {
    var successBlock: ((String) -> Void)?
    var failureBlock: ((String) -> Void)?
    func startRecognition(success: @escaping (String) -> Void,
                          failure: ((String) -> Void)?) {
        successBlock = success
        failureBlock = failure
    }
    
    func stopRecognition() {}
}
