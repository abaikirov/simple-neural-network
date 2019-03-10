//
//  NNOutputLayer.swift
//  NeuralNetwork
//
//  Created by Abai Abakirov on 12/22/18.
//  Copyright © 2018 abaikirov. All rights reserved.
//

import Foundation

final class NNOutputLayer: NNLayer {
  
  init(size: Int, activation: NNActivation) {
    super.init(inputSize: size, outSize: size, activation: activation)
  }
  
  override func run(inputValues: [Double]) -> [Double] {
    self.inputValues = inputValues
    for output in 0..<outSize {
      outputValues[output] = inputValues[output]
    }
    return outputValues
  }
  
  func delta(ideals: [Double]) {
    for index in 0..<inputSize {
      deltas[index] = (ideals[index] - outputValues[index]) * activation.derivative(x: inputValues[index])
    }
  }
}
