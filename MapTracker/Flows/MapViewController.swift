//
//  MapViewController.swift
//  MapTracker
//
//  Created by Andrey Pozdnyakov on 18.11.2023.
//

import GoogleMaps
import SwiftUI
import UIKit

class MapViewController: UIViewController {

    let map = GMSMapView()

    override func loadView() {
        super.loadView()
        self.view = map
    }
}
