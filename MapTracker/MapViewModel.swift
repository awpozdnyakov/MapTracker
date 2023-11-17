//
//  MapViewModel.swift
//  MapTracker
//
//  Created by Andrey Pozdnyakov on 17.11.2023.
//

import SwiftUI
import GoogleMaps

class MapViewModel: ObservableObject {
    @Published var coordinates = CLLocationCoordinate2D(latitude: 37.34033264974476, longitude: -122.06892632102273)
    var marker: GMSMarker?

    func addMarker(mapView: GMSMapView) {
        marker = GMSMarker(position: coordinates)
        marker?.map = mapView
    }
}
