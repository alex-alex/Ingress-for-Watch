//
//  LoadingInterfaceController.swift
//  Ingress
//
//  Created by Alex Studnicka on 06/06/15.
//  Copyright (c) 2015 Alex Studnicka. All rights reserved.
//

import WatchKit
import Foundation
import CoreLocation

class LoadingInterfaceController: WKInterfaceController {
	
	override func awakeWithContext(context: AnyObject?) {
		super.awakeWithContext(context)
		
		let playerCoord = CLLocation(latitude: 37.7843129, longitude: -122.4081764)
		
		let params = [
			"params": [
				"clientBasket": [
					"clientBlob": "..."
				],
				"knobSyncTimestamp": NSNumber(longLong: 1433620726909),
				"energyGlobGuids":NSNull(),
				"playerLocation":"02408af3,f8b432b6",
				"dates":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
				"cellsAsHex":["8085808650000000","8085808f10000000","8085808450000000","8085808550000000","8085808610000000","8085808f50000000","8085808410000000","8085808510000000","8085808f90000000","80858085d0000000","8085808890000000","8085808690000000","8085808fd0000000","8085808590000000","80858088d0000000","8085808670000000","8085808f30000000","8085808570000000","8085808630000000","8085808f70000000","8085808430000000","80858088b0000000","80858086f0000000","8085808fb0000000","80858084f0000000","80858085f0000000","80858086b0000000","8085808ff0000000","80858085b0000000"],
				"cells":NSNull()
			]
		]

		let request = NSMutableURLRequest(URL: NSURL(string: "https://m-dot-betaspike.appspot.com/rpc/gameplay/getObjectsInCells")!)
		request.HTTPMethod = "POST"
		do {
			request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: [])
		} catch _ {
			request.HTTPBody = nil
		}

		request.setValue("Nemesis (gzip)", forHTTPHeaderField: "User-Agent")
		request.setValue("Bearer ...", forHTTPHeaderField: "Authorization")
		request.setValue("...", forHTTPHeaderField: "X-XsrfToken")
		request.setValue("SACSID=...", forHTTPHeaderField: "Cookie")
		
		let session = NSURLSession.sharedSession()
		let task = session.dataTaskWithRequest(request) { data, response, error in
			
			var _result: [String: AnyObject]? = nil
			do {
				_result = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String : AnyObject]
			} catch _ {
				_result = nil
			}
			
			if let result = _result {
				
				let gameBasket = result["gameBasket"] as! [String: AnyObject]
				let gameEntities = gameBasket["gameEntities"] as! [AnyObject]
				
				var portals = [[String: AnyObject]]()
				
				for gameEntity in gameEntities {
					let details = gameEntity[2] as! [String: AnyObject]
					if let descriptiveText = details["descriptiveText"] as? [String: AnyObject] {
						let map = descriptiveText["map"] as! [String: AnyObject]
						let title = map["TITLE"] as! String
						
						let locationE6 = details["locationE6"] as! [String: AnyObject]
						let latE6 = locationE6["latE6"] as! NSNumber
						let lngE6 = locationE6["lngE6"] as! NSNumber
						let lat = latE6.doubleValue / 1E6
						let lng = lngE6.doubleValue / 1E6
						let coord = CLLocation(latitude: lat, longitude: lng)
						
						let photoStreamInfo = details["photoStreamInfo"] as! [String: AnyObject]
						let coverPhoto = photoStreamInfo["coverPhoto"] as! [String: AnyObject]
						let imageUrl = coverPhoto["imageUrl"] as! String
						
						let controllingTeam = details["controllingTeam"] as! [String: AnyObject]
						let team = controllingTeam["team"] as! String
						
						portals.append([
							"title": title,
							"coord": coord,
							"image": imageUrl,
							"team": team
							])
					}
				}
				
				portals.sortInPlace { (p1, p2) -> Bool in
					let coord1 = p1["coord"] as! CLLocation
					let dist1 = coord1.distanceFromLocation(playerCoord)
					let coord2 = p2["coord"] as! CLLocation
					let dist2 = coord2.distanceFromLocation(playerCoord)
					return dist1 < dist2
				}
				
				portals = Array(portals[0..<10]) as [[String: AnyObject]]
				
				portals = portals.filter { (p) -> Bool in
					let coord = p["coord"] as! CLLocation
					let dist = coord.distanceFromLocation(playerCoord)
					return dist < 250
				}
				
				var interfaces = ["Overview"]
				for _ in portals { interfaces.append("PortalController") }
				
				WKInterfaceController.reloadRootControllersWithNames(interfaces, contexts: portals)
				
			} else {
				print("result error")
			}

		}
		
		task?.resume()
		
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
