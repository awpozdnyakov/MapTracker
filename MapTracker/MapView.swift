//
//  MapView.swift
//  MapTracker
//
//  Created by Andrey Pozdnyakov on 17.11.2023.
//

import SwiftUI
import GoogleMaps

struct MapView: UIViewRepresentable {
    @ObservedObject var mapViewModel = MapViewModel()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(mapViewModel: mapViewModel)
    }

    func makeUIView(context: Context) -> GMSMapView {
        let mapView = GMSMapView()

        let camera = GMSCameraPosition.camera(withTarget: mapViewModel.coordinates, zoom: 12.0)
        mapView.camera = camera

        let button = UIButton(type: .system)
        button.setTitle("Добавить маркер", for: .normal)
        button.addTarget(context.coordinator, action: #selector(Coordinator.addMarker(_:)), for: .touchUpInside)

        mapView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -10),
            button.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -10)
        ])

        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {}

    class Coordinator: NSObject {
        var mapViewModel: MapViewModel

        init(mapViewModel: MapViewModel) {
            self.mapViewModel = mapViewModel
        }

        @objc func addMarker(_ sender: UIButton) {
            guard let mapView = sender.superview as? GMSMapView else { return }
            mapViewModel.addMarker(mapView: mapView)
        }
    }
}
