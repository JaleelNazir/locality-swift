//
//  UIImageExtension.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/9/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import Foundation

extension UIImage {

    func tinted(color:UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        color.setFill()
        let bounds = CGRect(origin:CGPoint.zero, size:self.size)
        UIRectFill(bounds)
        self.draw(in: bounds, blendMode: .multiply, alpha: 1.0)
        
        let tintedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return tintedImage
    }
    
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width*2
        let height = size.height*2
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
    
    func averageColor() -> UIColor {
        
        let pixel = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContext(pixel)
        
        let ctx: CGContext = UIGraphicsGetCurrentContext()!
        ctx.interpolationQuality = .medium
        
        draw(in: CGRect(origin: CGPoint.zero, size: pixel), blendMode: .copy, alpha: 1)
        
        let red = CGFloat((ctx.data?.load(fromByteOffset: 2, as: UInt8.self))!)
        let green = CGFloat((ctx.data?.load(fromByteOffset: 1, as: UInt8.self))!)
        let blue = CGFloat((ctx.data?.load(fromByteOffset: 0, as: UInt8.self))!)
    
        let avgColor = UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
        
        print("Red, Green, Blue: \(red, green, blue)")
        print("Hex: \(avgColor.toHexString)")
        
        UIGraphicsEndImageContext()
        
        return avgColor
        
    }
}
