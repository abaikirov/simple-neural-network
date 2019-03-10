//
//  Compressor.swift
//  NeuralNetwork
//
//  Created by Abai Abakirov on 12/22/18.
//  Copyright © 2018 abaikirov. All rights reserved.
//

import Foundation
import Cocoa
import ImageIO

class ImageService {
  func downsample(imageAt imageURL: URL, to pointSize: CGSize) -> NSImage {
    let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
    let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions)!
    let maxDimensionInPixels = max(pointSize.width, pointSize.height)
    let downsampleOptions = [
      kCGImageSourceCreateThumbnailFromImageAlways: true,
      kCGImageSourceShouldCacheImmediately: true,
      kCGImageSourceCreateThumbnailWithTransform: true,
      kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
      ] as CFDictionary
    
    guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
      fatalError("CGImageSourceCreateThumbnailAtIndex return nil")
    }
    return NSImage(cgImage: downsampledImage, size: pointSize)
  }
  
  func getProccessedData(image: NSImage) -> [Double] {
    let imageSize = image.size
    let imageRect = NSRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
    let dataSize = imageSize.width * imageSize.height
    var pixelData = [UInt8](repeating: 0, count: Int(dataSize))
    let colorSpace = CGColorSpaceCreateDeviceGray()
    let context = CGContext(data: &pixelData,
                            width: Int(imageSize.width),
                            height: Int(imageSize.height),
                            bitsPerComponent: 8,
                            bytesPerRow: Int(imageSize.width),
                            space: colorSpace,
                            bitmapInfo: CGImageAlphaInfo.none.rawValue)!
    guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
      fatalError()
    }
    
    context.draw(cgImage, in: imageRect)
    var result = [Double]()
    for height in 0..<Int(imageSize.height) {
      for width in 0..<Int(imageSize.width) {
        let value = pixelData[height * Int(imageSize.width) + width]
        result.append(Double(value))
      }
    }
    
    return result
  }
}


