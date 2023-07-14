import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    private let locationManager = LocationManager.shared
    private let networkManager = NetworkManager()
    
    private var allUniversities: [University]!
    private var currentLocation: CLLocation!

    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()

    private lazy var trackingButton: MKUserTrackingButton = {
        let trackingButton = MKUserTrackingButton(mapView: mapView)
        trackingButton.backgroundColor = .systemBackground
        trackingButton.translatesAutoresizingMaskIntoConstraints = false
        return trackingButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupModel()
        setupView()
    }

    private func setupModel() {
        
        networkManager.getUniversities { universities, error in
            if let error = error {
                print("Error : \(error)")
                return
            }
            guard let universities = universities else {
                print("Unknown Error")
                return
            }
            self.allUniversities = universities
            self.setAnnotations(at: self.allUniversities)

        }
        
        locationManager.requestLocationAccess()
        locationManager.getCurrentLocation { [weak self] location in
            guard let self = self else {
                return
            }
            if let location = location {
                self.currentLocation = location
                self.setCurrentLocation(at: self.currentLocation)
            }
        }
    }
    
    private func setupView() {
        self.title = "Maps"
        self.view.backgroundColor = .systemBackground
        mapView.delegate = self
        self.view.addSubview(mapView)
        self.view.addSubview(trackingButton)

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),

            trackingButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            trackingButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -32),
            trackingButton.widthAnchor.constraint(equalToConstant: 50),
            trackingButton.heightAnchor.constraint(equalToConstant: 50)

        ])
        
        let showListOfUniversitiesButton = UIBarButtonItem(
            image: UIImage(systemName: "list.dash"),
            style: .plain,
            target: self,
            action: #selector(showListOfUniversitiesButtonTapped))
        self.navigationItem.rightBarButtonItem = showListOfUniversitiesButton;
    }
    
    @objc private func showListOfUniversitiesButtonTapped() {
        let universitiesListViewController = UniversitiesListViewController(univeristies: allUniversities)
        universitiesListViewController.delegate = self
        navigationController?.pushViewController(universitiesListViewController, animated: true)
    }
}

extension MapViewController: UniversitiesListViewControllerDelegate {
    
    func showRoute(to coordinate: CLLocationCoordinate2D) {
        let currentPlacemark = MKPlacemark(coordinate: currentLocation.coordinate)
        let currentMapItem = MKMapItem(placemark: currentPlacemark)
        let destinationPlacemark = MKPlacemark(coordinate: coordinate)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let directionsRequest = MKDirections.Request()
        directionsRequest.source = currentMapItem
        directionsRequest.destination = destinationMapItem
        directionsRequest.transportType = .automobile
        directionsRequest.requestsAlternateRoutes = true
        let directions = MKDirections(request: directionsRequest)
        directions.calculate { response, error in
            if let error = error {
                print("Error calculating directions: \(error)")
                return
            }
            guard let route = response?.routes.first else {
                print("No route found")
                return
            }
            self.mapView.removeOverlays(self.mapView.overlays)
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    
    private func setAnnotations(at universities: [University]) {
        for university in universities {
            let attributes = university.attributes
            let geometry = university.geometry
            let annotation = MKPointAnnotation()
            annotation.title = attributes.universityChapter
            annotation.coordinate = CLLocationCoordinate2D(latitude: geometry.y, longitude: geometry.x)
            let universityLocation = CLLocation(latitude: geometry.y, longitude: geometry.x)
            annotation.subtitle = "\(attributes.city), \(attributes.state)"
            if let currentLocation = currentLocation {
                let distance = currentLocation.distance(from: universityLocation) / 1000
                let distanceString = String(format: "%.2f Km", distance)
                annotation.subtitle = "\(attributes.city), \(attributes.state)  | \(distanceString)"
            }
            self.mapView.addAnnotation(annotation)
        }
    }
    
    private func setCurrentLocation(at location: CLLocation) {
        let coordinates = location.coordinate
        let coordinatesSpan = MKCoordinateSpan(latitudeDelta: 0.1,longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinates, span: coordinatesSpan)
        mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.title = "My Current Location"
        annotation.coordinate = coordinates
        mapView.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseIdentifier = "UniversityAnnotation"
        if let existingView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) {
            return existingView
        } else {
            let annotationView = MKMarkerAnnotationView(annotation: annotation,
                                                        reuseIdentifier: reuseIdentifier)
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView,
                 annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {

        guard let universityAnnotation = view.annotation as? MKPointAnnotation else {
            return
        }
        if universityAnnotation.title == "My Current Location" {
            return
        }
        let universityCoordinates =  universityAnnotation.coordinate
        showRoute(to: universityCoordinates)
    }
    
    func mapView(_ mapView: MKMapView,
                 rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.blue.withAlphaComponent(0.7)
            renderer.lineWidth = 5
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}
