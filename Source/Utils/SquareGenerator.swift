//
//  SquareGenerator.swift
//  NeuralNetwork
//
//  Created by Abai Abakirov on 12/24/18.
//  Copyright © 2018 abaikirov. All rights reserved.
//

import Cocoa
import Foundation

class SquareGenerator {
  static func generate() {
    var str = "Hello, playground"
    
    // get URL to the the documents directory in the sandbox
    let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL
    
    // add a filename
    let fileUrl = documentsUrl.appendingPathComponent("foo.txt")
    
    // write to it
    try! str.write(to: fileUrl!, atomically: true, encoding: String.Encoding.utf8)
  }
}
