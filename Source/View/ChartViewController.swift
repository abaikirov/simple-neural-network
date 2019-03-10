//
//  ChartViewController.swift
//  NeuralNetwork
//
//  Created by Abai Abakirov on 12/22/18.
//  Copyright © 2018 abaikirov. All rights reserved.
//

import Cocoa
import Charts

class ChartViewController: NSViewController {
  var chartView: LineChartView?
  var entries: [ChartDataEntry] = []
  var data: [Double] = []
  let imageService = ImageService()
  let downImageSize = CGSize(width: 32, height: 32)
  var startDate = Date()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupChartView()
    train(getTrainingData())
  }
  
  func setupChartView() {
    chartView = LineChartView()
    if let chartView = chartView {
      view.addSubview(chartView)
      chartView.translatesAutoresizingMaskIntoConstraints = false
      
      NSLayoutConstraint.activate([
        chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        chartView.topAnchor.constraint(equalTo: view.topAnchor),
        chartView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
  }
  
  func drawSomeData() {
    let dataSet = LineChartDataSet(values: entries, label: "Learning")
    dataSet.drawCirclesEnabled = false
    let data = LineChartData(dataSet: dataSet)
    chartView?.data = data
    chartView?.notifyDataSetChanged()
  }
  
  func getTrainingData() -> ([[Double]], [[Double]]) {
    var datas = [[Double]]()
    var answers = [[Double]]()
    for index in 0..<32 {
      let imageName = "square\(index)"
      if let path = Bundle.main.pathForImageResource(imageName) {
        let url = URL(fileURLWithPath: path)
        let image = imageService.downsample(imageAt: url as URL, to: downImageSize)
        let data = imageService.getProccessedData(image: image)
        datas.append(data)
        if index > 15 {
          answers.append([0])
        } else {
          answers.append([1])
        }
      }
    }
    return (datas, answers)
  }
  
  func train(_ dataSet: ([[Double]], [[Double]])) {
    let testData: [[Double]] = dataSet.0
    let answers: [[Double]] = dataSet.1
    let network = NNNetwork(inputNeurons: 1024, hiddenLayers: [1024,512,256,128,64,32,16,8,4,2], outNeurons: 1)
    
    print("start \(printDate())")
    startDate = Date()
    
    DispatchQueue.global(qos: .background).async {
      network.train(dataSet: testData, answers: answers, onTrain: { cycle, error in
        DispatchQueue.main.async {
          self.entries.append(ChartDataEntry(x: Double(cycle), y: error))
          self.drawSomeData()
        }
      }, onFinish: {
        NNNetwork.NETWORK = network
        DispatchQueue.main.async {
          print("start \(self.printDate(self.startDate))")
          print("finish \(self.printDate())")
        }
      })
    }
  }
  
  func printDate(_ date: Date = Date()) -> String {
    let df = DateFormatter()
    df.dateFormat = "HH.mm.SS.sss"
    return df.string(from: date)
  }
}
