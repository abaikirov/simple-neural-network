//
//  ViewController.swift
//  NeuralNetwork
//
//  Created by Abai Abakirov on 12/20/18.
//  Copyright © 2018 abaikirov. All rights reserved.
//

import Cocoa
import Charts
import CoreGraphics

class ViewController: NSViewController {
  
  @IBOutlet weak var mainImageView: NSImageView!
  let imageService = ImageService()
  let downImageSize = CGSize(width: 32, height: 32)
  var data: [Double] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func onOpenImage(_ sender: Any) {
    let dialog = NSOpenPanel()
    dialog.title = "Choose an image"

    if dialog.runModal() == .OK {
      guard let url = dialog.url else {
        return
      }
      
      let downImage = imageService.downsample(imageAt: url, to: downImageSize)
      mainImageView.image = downImage
      data = imageService.getProccessedData(image: downImage)
    }
  }
  
  override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
    if segue.identifier == "to_chart_view" {
      let chartVC = segue.destinationController as? ChartViewController
      chartVC?.data = data
    } else if segue.identifier == "to_actual_data" {
      let vc = segue.destinationController as? ResultViewController
      vc?.data = data
    }
  }
}
