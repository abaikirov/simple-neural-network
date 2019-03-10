//
//  ResultViewController.swift
//  NeuralNetwork
//
//  Created by Abai Abakirov on 3/10/19.
//  Copyright © 2019 abaikirov. All rights reserved.
//

import Cocoa

class ResultViewController: NSViewController {
  
  var data: [Double] = []
  
  @IBOutlet weak var mainTextField: NSTextField!
  @IBOutlet weak var mainTextFieldCell: NSTextFieldCell!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let network = NNNetwork.NETWORK else {
      mainTextFieldCell.title = "Init neural network"
      return
    }
    
    let results = network.run(values: data)
    mainTextFieldCell.title = "\(results)"
  }
}
