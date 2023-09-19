//
//  File.swift
//  
//
//  Created by TriBQ on 30/05/2023.
//

import Foundation
import MapKit

public extension MKCoordinateRegion {
    func openMap(name: String) {
        let placemark = MKPlacemark(coordinate: self.center, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name

        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: self.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: self.span)
        ]
        mapItem.openInMaps(launchOptions: options)
    }
}
