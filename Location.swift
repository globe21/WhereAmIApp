//
//  MyLocation.swift
//  WhereAmIApp
//
//  Created by Uğur on 20/05/15.
//  Copyright (c) 2015 ceuur. All rights reserved.
//

import Foundation
import CoreLocation

class Location{
    var location : CLLocation
    var locality = ""
    var postalCode = ""
    var administrativeArea = ""
    var country = ""

    init(location: CLLocation){
        self.location = location
        setLocationInformaitons()
    }
    
    private func setLocationInformaitons(){
        let geocoder = CLGeocoder()
        
        let placemarks: Void = geocoder.reverseGeocodeLocation(location, completionHandler: nil)
        
        let placemark = placemarks.last as! CLPlacemark
        self.locality = (placemark.locality != nil) ? placemark.locality : ""
        self.postalCode = (placemark.postalCode != nil) ? placemark.postalCode : ""
        self.administrativeArea = (placemark.administrativeArea != nil) ? placemark.administrativeArea : ""
        self.country = (placemark.country != nil) ? placemark.country : ""
        
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, e) -> Void in
            if let error = e {
                println("Error:  (e.localizedDescription)")
            } else {
                let
            }
        })
    }
}