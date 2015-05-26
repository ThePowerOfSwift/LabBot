//
//  LBImageView.swift
//  LabBot
//
//  Created by Lee Walsh on 25/05/2015.
//  Copyright (c) 2015 Lee David Walsh. All rights reserved.
//

import Cocoa

public class LBImageView: NSView {
    public var image: NSImage?
    public var allowMarker = false
    private(set) public var markerLocation = LBPoint(x: -1.0, y: -1.0)
    public var markerSize = 20.0

    public override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
        if image != nil {
            self.frame = NSRect(origin: NSPoint(x: 0.0, y: 0.0), size: image!.size)
            image!.drawInRect(self.frame)
        } else {
            self.frame = NSRect(x: 0.0, y: 0.0, width: 1000.0, height: 1000.0)
            DRHBlankImage.blankImageOfSize(frame.size).drawInRect(frame)
        }
        
        if markerLocation.x >= 0 && markerLocation.y >= 0 {
            var markerPath = NSBezierPath()
            markerPath.moveToPoint(NSPoint(x: markerLocation.x-markerSize, y: markerLocation.y-markerSize))
            markerPath.lineToPoint(NSPoint(x: markerLocation.x+markerSize, y: markerLocation.y+markerSize))
            markerPath.moveToPoint(NSPoint(x: markerLocation.x-markerSize, y: markerLocation.y+markerSize))
            markerPath.lineToPoint(NSPoint(x: markerLocation.x+markerSize, y: markerLocation.y-markerSize))
            NSColor.redColor().setStroke()
            markerPath.stroke()
        }
    }
    
    public override func mouseDown(theEvent: NSEvent) {
        markerLocation = LBPoint(point: self.convertPoint(theEvent.locationInWindow, fromView: nil))
        self.needsDisplay = true
    }
    
    public func clearMarker(){
        markerLocation = LBPoint(x: -1.0, y: -1.0)
    }
    
}
