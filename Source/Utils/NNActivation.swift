//
//  NNActivation.swift
//  NeuralNetwork
//
//  Created by Abai Abakirov on 12/20/18.
//  Copyright © 2018 abaikirov. All rights reserved.
//

import Foundation

class NNActivation {
  enum Function {
    case sigmoid
    case tangens
  }
  
  let function: Function
  
  init(type: Function) {
    function = type
  }
  
  func activate(x: Double) -> Double {
    switch function {
    case .sigmoid:
      return sigmoid(x: x)
    case .tangens:
      return tangens(x: x)
    }
  }
  
  func derivative(x: Double) -> Double {
    switch function {
    case .sigmoid:
      return sigmoidDir(x: x)
    case .tangens:
      return tangensDir(x: x)
    }
  }
  
  private func sigmoidDir(x: Double) -> Double {
    return (1 - x) * x
  }
  
  private func tangensDir(x: Double) -> Double {
    return 1 - pow(x, 2)
  }
  
  private func sigmoid(x: Double) -> Double {
    return 1 / (1 + pow(M_E, -x))
  }
  
  private func tangens(x: Double) -> Double {
    return (pow(M_E, 2 * x) - 1) / (pow(M_E, 2 * x) + 1)
  }
}
