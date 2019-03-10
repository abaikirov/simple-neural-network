//
//  NNLayer.swift
//  NeuralNetwork
//
//  Created by Abai Abakirov on 12/20/18.
//  Copyright © 2018 abaikirov. All rights reserved.
//

import Foundation

class NNLayer {
  let inputSize: Int
  let outSize: Int
  let activation: NNActivation
  var weights: [[Double]]
  var diffs: [[Double]]
  var deltas: [Double]
  var inputValues: [Double]
  var outputValues: [Double]
  
  init(inputSize: Int, outSize: Int, activation: NNActivation) {
    self.inputSize = inputSize
    self.outSize = outSize
    self.activation = activation
    
    deltas = [Double](repeating: 0, count: inputSize)
    outputValues = [Double](repeating: 0, count: outSize)
    weights = [[Double]](repeating: [Double](), count: inputSize)
    diffs = [[Double]](repeating: [Double](), count: inputSize)
    inputValues = [Double](repeating: 0, count: inputSize)
    
    for input in 0..<inputSize {
      var lWeight = [Double](repeating: 0, count: outSize)
      let lDiff = [Double](repeating: 0, count: outSize)
      for output in 0..<outSize {
        lWeight[output] = Double.random(in: -2.0...2.0)
      }
      weights[input] = lWeight
      diffs[input] = lDiff
    }
  }
  
  func run(inputValues: [Double]) -> [Double] {
    self.inputValues = inputValues
    guard inputValues.count == inputSize else {
      fatalError()
    }
    
    for output in 0..<outSize {
      var outputValue: Double = 0
      for input in 0..<inputValues.count {
        outputValue += inputValues[input] * weights[input][output]
      }
      outputValues[output] = activation.activate(x: outputValue)
    }
    return outputValues
  }
  
  
  
  func delta(outDeltas: [Double]) {
    for input in 0..<inputSize {
      var summ: Double = 0
      for output in 0..<outSize {
        summ += weights[input][output] * outDeltas[output]
      }
      
      deltas[input] = activation.derivative(x: inputValues[input]) * summ
    }
  }
  
  func mop(outDeltas: [Double]) {
    for input in 0..<inputSize {
      for output in 0..<outSize {
        let grad = inputValues[input] * outDeltas[output]
        diffs[input][output] = NNNetwork.LEARNING_RATE * grad + NNNetwork.MOMENT * diffs[input][output]
        weights[input][output] += diffs[input][output]
      }
    }
  }
}
