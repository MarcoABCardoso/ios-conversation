//
//  ClassificationApiMock.swift
//  ChatDemo
//
//  Created by Marco Aurélio Bigélli Cardoso on 01/08/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation
@testable import ChatDemo

class ClassificationApiMock: ClassificationApi {
    var successBlock: ((String) -> ())?
    var failureBlock: ((String) -> ())?
    var context: [String: Any?] = [:]
    func classify(text: String, success: @escaping (String) -> (), failure: ((String) -> ())?) {
        successBlock = success
        failureBlock = failure
    }
    
    func cancel() {
        failureBlock?("Cancelled")
    }
}
