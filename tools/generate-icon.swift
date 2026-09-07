// Oring app icon source. The PNG in Assets.xcassets is rendered from this geometry.
import AppKit
import CoreGraphics
import Foundation

guard CommandLine.arguments.count == 2 else {
    fputs("usage: swift tools/generate-icon.swift /path/to/icon-1024.png\n", stderr)
    exit(2)
}

let side = 1024
let colorSpace = CGColorSpaceCreateDeviceRGB()
let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
guard let context = CGContext(data: nil, width: side, height: side,
                              bitsPerComponent: 8, bytesPerRow: 0,
                              space: colorSpace, bitmapInfo: bitmapInfo) else { exit(1) }

func color(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> CGColor {
    CGColor(colorSpace: colorSpace, components: [r / 255, g / 255, b / 255, 1])!
}

context.setFillColor(color(16, 27, 37))
context.fill(CGRect(x: 0, y: 0, width: side, height: side))

let center = CGPoint(x: 512, y: 512)
context.setStrokeColor(color(54, 75, 88))
context.setLineWidth(6)
context.strokeEllipse(in: CGRect(x: 164, y: 164, width: 696, height: 696))

context.setStrokeColor(color(242, 172, 99))
context.setLineWidth(68)
context.setLineCap(.round)
context.addArc(center: center, radius: 257,
               startAngle: .pi * 0.31, endAngle: .pi * 2.18, clockwise: false)
context.strokePath()

context.setFillColor(color(244, 241, 233))
context.fillEllipse(in: CGRect(x: 479, y: 479, width: 66, height: 66))

guard let image = context.makeImage(),
      let png = NSBitmapImageRep(cgImage: image).representation(using: .png, properties: [:]) else { exit(1) }
try png.write(to: URL(fileURLWithPath: CommandLine.arguments[1]))
