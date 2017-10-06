//
//  ClassificationApi.swift
//  ChatDemo
//
//  Created by Marco Aurélio Bigélli Cardoso on 28/08/17.
//  Copyright © 2017 IBM. All rights reserved.
//

protocol RecognitionApi: class {
    func startRecognition(success: @escaping (String) -> Void,
                          failure: ((String) -> Void)?)
    func stopRecognition()
}

protocol ClassificationApi: class {
    func classify(text: String,
                  success: @escaping (String) -> (),
                  failure: ((String) -> ())?)
    func cancel()
}

protocol SynthesisApi: class {
    func synthesize(text: String,
                    speechStart:  ((Void) -> Void)?,
                    success: ((Void) -> Void)?,
                    failure: ((String) -> Void)?)
    func cancel()
}
