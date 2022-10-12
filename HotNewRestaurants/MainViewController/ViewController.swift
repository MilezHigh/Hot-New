//
//  ViewController.swift
//  HotNewRestaurants
//
//  Created by Miles Fishman on 10/11/22.
//

import UIKit
import Combine
import CoreLocation

class ViewController: UIViewController {
    lazy var tableView: UITableView = {
        let t = UITableView()
        t.delegate = self
        t.dataSource = self
        t.backgroundColor = .clear
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()
    
    private var cancellable: AnyCancellable?
    private var currentLocation: CLLocation?
    private var locationManager: CLLocationManager?
    
    var viewModel: MainViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        registerCells()
        registerSubscribers()
    }
    
    private func setup() {
        // Setup Views
        title = "Hot & New"
        
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Setup Location Manager
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        if locationManager?.authorizationStatus != .authorizedWhenInUse
            && locationManager?.authorizationStatus != .authorizedAlways {
            locationManager?.requestWhenInUseAuthorization()
        } else {
            requestLocation()
        }
    }
    
    private func registerCells() {
        tableView.register(YelpTableViewCell.self,
                           forCellReuseIdentifier: YelpTableViewCell.reuseIdentifier)
    }
    
    private func registerSubscribers() {
        cancellable = viewModel?.$businesses
            .receive(on: RunLoop.main)
            .sink { [weak self] values in
                self?.tableView.reloadData()
            }
    }
    
    private func requestLocation() {
        currentLocation = nil
        locationManager?.startUpdatingLocation()
    }
}

// MARK: UITableView Methods
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.businesses.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: YelpTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? YelpTableViewCell
        else { return UITableViewCell() }
        
        cell.model = viewModel?.businesses[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? YelpTableViewCell,
              let model = cell.model
        else { return }
        
        let detailsController = YelpDetailsViewController()
        let detailsViewModel = YelpDetailsViewModel(yelpBusinessModel: model)
        detailsController.viewModel = detailsViewModel
        navigationController?.pushViewController(detailsController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: CLLocation Methods
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first, currentLocation == nil {
            manager.stopUpdatingLocation()
            
            currentLocation = location

            viewModel?.searchLocalBusinesses(longitude: location.coordinate.longitude,
                                             latitude: location.coordinate.latitude)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            requestLocation()
            
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
        requestLocation()
    }
}
