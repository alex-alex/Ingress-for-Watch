//
//  HackingInterfaceController.swift
//  Ingress
//
//  Created by Alex Studnicka on 06/06/15.
//  Copyright (c) 2015 Alex Studnicka. All rights reserved.
//

import WatchKit
import Foundation

class HackingInterfaceController: WKInterfaceController {
	
	override func awakeWithContext(context: AnyObject?) {
		super.awakeWithContext(context)
		
		let ic = context as! PortalInterfaceController
		
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2*NSEC_PER_SEC)), dispatch_get_main_queue()) {
			self.dismissController()
			ic.presentControllerWithName("Acquired", context: nil)
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
	
}
