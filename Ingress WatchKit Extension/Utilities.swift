//
//  Utilities.swift
//  Ingress
//
//  Created by Alex Studnicka on 06/06/15.
//  Copyright (c) 2015 Alex Studnicka. All rights reserved.
//

import Foundation
import WatchKit
import CoreLocation

public extension WKInterfaceImage {
	
	public func setImageWithUrl(url:String) -> WKInterfaceImage? {
		
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
			let url:NSURL = NSURL(string:url)!
			let data:NSData = NSData(contentsOfURL: url)!
			let placeholder = UIImage(data: data)!
			
			dispatch_async(dispatch_get_main_queue()) {
				self.setImage(placeholder)
			}
		}
		
		return self
	}
	
}

func degreesToRadians(x: Double) -> Double {
	return (M_PI * x / 180.0)
}

func radiandsToDegrees(x: Double) -> Double {
	return (x * 180.0 / M_PI)
}

func angleToDirection(angle: CLLocationDegrees) -> String {
	if angle >= 22.5 && angle < 67.5 {
		return "NE"
	} else if angle >= 67.5 && angle < 112.5 {
		return "E"
	} else if angle >= 112.5 && angle < 157.5 {
		return "SE"
	} else if angle >= 157.5 && angle < 202.5 {
		return "S"
	} else if angle >= 202.5 && angle < 247.5 {
		return "SW"
	} else if angle >= 247.5 && angle < 292.5 {
		return "W"
	} else if angle >= 292.5 && angle < 337.5 {
		return "NW"
	} else {
		return "N"
	}
}

public extension CLLocation {
	
	public func bearingToLocation(location: CLLocation) -> CLLocationDegrees {
		let fromLoc = self.coordinate
		let toLoc = location.coordinate
		let fLat = degreesToRadians(fromLoc.latitude)
		let fLng = degreesToRadians(fromLoc.longitude)
		let tLat = degreesToRadians(toLoc.latitude)
		let tLng = degreesToRadians(toLoc.longitude)
		let degree = radiandsToDegrees(atan2(sin(tLng-fLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(tLng-fLng)))
		if degree >= 0 { return degree }
		return 360+degree
	}
	
}

extension Int {
	func format(f: String) -> String {
		return NSString(format: "%\(f)d", self) as String
	}
}

extension Double {
	func format(f: String) -> String {
		return NSString(format: "%\(f)f", self) as String
	}
}
