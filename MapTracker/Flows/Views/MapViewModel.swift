//
//  MapViewModel.swift
//  MapTracker
//
//  Created by Andrey Pozdnyakov on 17.11.2023.
//

import SwiftUI
import GoogleMaps

class MapViewModel: ObservableObject {
    @Published var coordinates = [CLLocationCoordinate2D]()
    var route: GMSPolyline?
    @Published var coordinate = CLLocationCoordinate2D(latitude: 37.610225, longitude: 55.651365)
    @Published var locations: [LocationModel] = []  // Используйте locations вместо coordinates
    @Published var zoom: Float = 10.0
    var marker: GMSMarker?
    
    //    var mapView: GMSMapView?
    
    struct LocationModel: Decodable {
        let timestamp: String
        let latitude: Double
        let longitude: Double
    }
    
    
    
    func fetchDataAndDrawPolyline(mapView: GMSMapView) {
        guard let url = URL(string: "https://dev5.skif.pro/coordinates.json") else {
            return // Некорректный URL
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[Any]] ?? []
                
                // Конвертировать JSON в массив LocationModel
                let locations = self?.convertToNewFormat(oldFormat: jsonArray) ?? []
                
                DispatchQueue.main.async {
                    self?.drawPolyline(mapView: mapView, locations: locations)
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        
        task.resume()
    }
    
    func drawPolyline(mapView: GMSMapView, locations: [LocationModel]) {
        // Очистить предыдущую полилинию, если она существует
        route?.map = nil
        
        // Очистить массив координат
        self.coordinates.removeAll()
        
        // Добавить координаты из LocationModel
        for location in locations {
            let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            self.coordinates.append(coordinate)
        }
        
        // Построить полилинию
        let path = GMSMutablePath()
        for coordinate in self.coordinates {
            path.add(coordinate)
        }
        route = GMSPolyline(path: path)
        route?.strokeWidth = 5.0
        route?.strokeColor = .green
        route?.map = mapView
        
        // При необходимости, вы можете также настроить камеру карты
        if let lastCoordinate = self.coordinates.last {
            mapView.animate(toLocation: lastCoordinate)
        }
    }
    
    func convertToNewFormat(oldFormat: [[Any]]) -> [LocationModel] {
        return oldFormat.compactMap { element -> LocationModel? in
            guard element.count == 3,
                  let timestamp = element[0] as? String,
                  let latitude = element[1] as? Double,
                  let longitude = element[2] as? Double else {
                return nil
            }
            return LocationModel(timestamp: timestamp, latitude: latitude, longitude: longitude)
        }
    }
    
    func addMarker(mapView: GMSMapView) {
        marker?.map = nil
        marker = GMSMarker(position: coordinates.randomElement() ?? coordinate)
        let point = CGRect(x: 0, y: 0, width: 20, height: 20)
        let viewPoint = UIView(frame: point)
        viewPoint.layer.cornerRadius = 10
        viewPoint.backgroundColor = .blue
        marker?.iconView = viewPoint
        marker?.map = mapView
        mapView.animate(toLocation: coordinate)
    }
}
