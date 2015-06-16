//
//  InterfaceController.swift
//  Ingress WatchKit Extension
//
//  Created by Alex Studnicka on 06/06/15.
//  Copyright (c) 2015 Alex Studnicka. All rights reserved.
//

import WatchKit
import Foundation

class PortalInterfaceController: WKInterfaceController {

	@IBOutlet weak var nameLabel: WKInterfaceLabel!
	@IBOutlet weak var portalImage: WKInterfaceImage!
	@IBOutlet weak var portalMap: WKInterfaceMap!
	var loadedImage: UIImage!
	
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
		
		if let portal = context as? [String: AnyObject] {
			
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
				let url:NSURL = NSURL(string: portal["image"] as! String)!
				let data:NSData = NSData(contentsOfURL: url)!
				let placeholder = UIImage(data: data)!
				self.loadedImage = placeholder
				dispatch_async(dispatch_get_main_queue()) {
					self.portalImage.setImage(placeholder)
				}
			}
			
			let title = portal["title"] as! String
			nameLabel.setText(title)
			
			let playerCoord = CLLocation(latitude: 37.7843129, longitude: -122.4081764)
			let coord = portal["coord"] as! CLLocation
			let dist = coord.distanceFromLocation(playerCoord)
			let formattedDist = dist.format(".1")
			let angle = playerCoord.bearingToLocation(coord)
			self.setTitle("\(formattedDist)m \(angleToDirection(angle))")
			
			portalMap.setRegion(MKCoordinateRegionMakeWithDistance(coord.coordinate, 100, 100))
			
			addMenuItemWithImageNamed("hack", title: "HACK", action: "hack")
			
			let team = portal["team"] as! String
			switch team {
			case "ALIENS":
				nameLabel.setTextColor(UIColor.greenColor())
				portalMap.addAnnotation(coord.coordinate, withImageNamed: "green", centerOffset: CGPointZero)
				addMenuItemWithImageNamed("deploy", title: "DEPLOY", action: "deploy")
				addMenuItemWithImageNamed("recharge", title: "RECHARGE", action: "recharge")
			case "RESISTANCE":
				nameLabel.setTextColor(UIColor(red: 0, green: 0.5, blue: 1, alpha: 1))
				portalMap.addAnnotation(coord.coordinate, withImageNamed: "blue", centerOffset: CGPointZero)
				addMenuItemWithImageNamed("fire", title: "FIRE", action: "fire")
				addMenuItemWithImageNamed("virus", title: "VIRUS", action: "virus")
			case "NEUTRAL":
				nameLabel.setTextColor(UIColor.grayColor())
				portalMap.addAnnotation(coord.coordinate, withImageNamed: "gray", centerOffset: CGPointZero)
				addMenuItemWithImageNamed("deploy", title: "DEPLOY", action: "deploy")
			default:
				nameLabel.setTextColor(UIColor.whiteColor())
			}
			
			portalMap.addAnnotation(playerCoord.coordinate, withImageNamed: "user", centerOffset: CGPointZero)
			
		}
		
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
	
	// Actions
	
	@IBAction func displayImage() {
		presentControllerWithName("Image", context: self.loadedImage)
	}
	
	func hack() {
		presentControllerWithName("Hacking", context: self)
	}
	
	func deploy() {
		
	}
	
	func recharge() {
		
	}
	
	func fire() {
		presentControllerWithName("Firing", context: self)
	}
	
	func virus() {
		
	}

}
