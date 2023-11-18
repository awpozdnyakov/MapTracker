//
//  MapView.swift
//  MapTracker
//
//  Created by Andrey Pozdnyakov on 17.11.2023.
//

import SwiftUI
import GoogleMaps

struct MappView: UIViewRepresentable {
    @ObservedObject var mapViewModel = MapViewModel()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(mapViewModel: mapViewModel)
    }

    func makeUIView(context: Context) -> GMSMapView {
        let mapView = GMSMapView()

        let camera = GMSCameraPosition.camera(withTarget: mapViewModel.coordinate, zoom: mapViewModel.zoom)
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

        let button2 = UIButton(type: .system)
        button2.setTitle("Нарисовать", for: .normal)
        button2.addTarget(context.coordinator, action: #selector(Coordinator.draw(_:)), for: .touchUpInside)

        mapView.addSubview(button2)
                button2.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    button2.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -15),
                    button2.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -30)
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
        
        @objc func draw(_ sender: UIButton) {
            guard let mapView = sender.superview as? GMSMapView else { return }
            mapViewModel.fetchDataAndDrawPolyline(mapView: mapView)
        }
    }
}

/// The wrapper for `GMSMapView` so it can be used in SwiftUI
struct MapView: UIViewRepresentable {

  @Binding var markers: [GMSMarker]
  @Binding var selectedMarker: GMSMarker?

  var onAnimationEnded: () -> ()

  private let gmsMapView = GMSMapView()
  private let defaultZoomLevel: Float = 10

  func makeUIView(context: Context) -> GMSMapView {
    let sanFrancisco = CLLocationCoordinate2D(latitude: 37.7576, longitude: -122.4194)
    gmsMapView.camera = GMSCameraPosition.camera(withTarget: sanFrancisco, zoom: defaultZoomLevel)
    gmsMapView.delegate = context.coordinator
    gmsMapView.isUserInteractionEnabled = true
    return gmsMapView
  }

  func updateUIView(_ uiView: GMSMapView, context: Context) {
    markers.forEach { marker in
      marker.map = uiView
    }
    if let selectedMarker = selectedMarker {
      let camera = GMSCameraPosition.camera(withTarget: selectedMarker.position, zoom: defaultZoomLevel)
      print("Animating to position \(selectedMarker.position)")
      CATransaction.begin()
      CATransaction.setValue(NSNumber(floatLiteral: 5), forKey: kCATransactionAnimationDuration)
      gmsMapView.animate(with: GMSCameraUpdate.setCamera(camera))
      CATransaction.commit()
    }
  }

  func makeCoordinator() -> MapViewCoordinator {
    return MapViewCoordinator(self)
  }
  

  final class MapViewCoordinator: NSObject, GMSMapViewDelegate {
    var mapView: MapView

    init(_ mapView: MapView) {
      self.mapView = mapView
    }

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
//      let marker = GMSMarker(position: coordinate)
//      self.mapView.polygonPath.append(marker)
    }

    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
      self.mapView.onAnimationEnded()
    }

  }
}
