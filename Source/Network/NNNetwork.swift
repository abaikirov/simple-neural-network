//
//  NNNetwork.swift
//  NeuralNetwork
//
//  Created by Abai Abakirov on 12/21/18.
//  Copyright © 2018 abaikirov. All rights reserved.
//

import Foundation

class NNNetwork {
  
  static var NETWORK: NNNetwork? = nil
  
  static let LEARNING_RATE = 0.9
  static let MOMENT = 0.8
  
  let tolerance = 0.1
  
  let activation = NNActivation(type: .sigmoid)
  
  let layers: [NNLayer]
  
  init(inputNeurons: Int, hiddenLayers: [Int], outNeurons: Int) {
    var lLayers = [NNLayer]()
    lLayers.append(NNInputLayer(inputSize: inputNeurons, outSize: hiddenLayers[0], activation: activation))
    if hiddenLayers.count > 1 {
      for hiddenIndex in 0..<hiddenLayers.count - 1 {
        lLayers.append(NNHiddenLayer(inputSize: hiddenLayers[hiddenIndex], outSize: hiddenLayers[hiddenIndex + 1], activation: activation))
      }
    }
    lLayers.append(NNHiddenLayer(inputSize: hiddenLayers[hiddenLayers.count - 1], outSize: outNeurons, activation: activation))
    lLayers.append(NNOutputLayer(size: outNeurons, activation: activation))
    
    layers = lLayers
  }
  
  func train(dataSet: [[Double]], answers: [[Double]], onTrain: @escaping (Int, Double) -> Void, onFinish: @escaping () -> Void) {
    var totalErrorRate = 10.0
    var counter = 0
    while totalErrorRate > tolerance {
      var epochError = 0.0
      for testIndex in 0..<dataSet.count {
        // Run
        var results = dataSet[testIndex]
        for layer in layers {
          results = layer.run(inputValues: results)
        }
        
        //Error
        var error = 0.0
        for resultIndex in 0..<results.count {
          error += pow((answers[testIndex][resultIndex] - results[resultIndex]),2)
        }
        epochError += error / Double(results.count)
        
        //MOP
        for reversedIndex in 0..<layers.count {
          let index = layers.count - reversedIndex - 1
          if let outLayer = layers[index] as? NNOutputLayer {
            outLayer.delta(ideals: answers[testIndex])
          } else if let inLayer = layers[index] as? NNInputLayer {
            inLayer.mop(outDeltas: layers[index + 1].deltas)
          } else {
            layers[index].delta(outDeltas: layers[index + 1].deltas)
            layers[index].mop(outDeltas: layers[index + 1].deltas)
          }
          print("layer index: \(reversedIndex)")
        }
      }
      
      totalErrorRate = epochError / Double(dataSet.count)
      counter += 1
      onTrain(counter, totalErrorRate)
      print("network: \(counter)")
    }
    onFinish()
    print("total epochs \(counter)")
  }
  
  func run(values: [Double]) -> [Double] {
    var results = values
    for layer in layers {
      results = layer.run(inputValues: results)
    }
    return results
  }
}
