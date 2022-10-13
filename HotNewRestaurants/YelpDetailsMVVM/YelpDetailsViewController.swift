//
//  YelpDetailsViewController.swift
//  HotNewRestaurants
//
//  Created by Miles Fishman on 10/12/22.
//

import UIKit
import Combine

class YelpDetailsViewController: UIViewController {
    lazy var tableView: UITableView = {
        let t = UITableView()
        t.delegate = self
        t.dataSource = self
        t.backgroundColor = .clear
        t.estimatedRowHeight = 100
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()
    
    var viewModel: YelpDetailsViewModel?
    
    private var cancellable: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        registerCells()
        registerSubscriptions()
    }
    
    deinit {
        print("\(Self.description()) Deallocated")
    }
    
    private func setup() {
        title = viewModel?.yelpBusinessModel.name
        
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func registerCells() {
        tableView.register(YelpTableViewCell.self, forCellReuseIdentifier: YelpTableViewCell.reuseIdentifier)
        tableView.register(YelpReviewViewCell.self, forCellReuseIdentifier: YelpReviewViewCell.reuseIdentifier)
    }
    
    private func registerSubscriptions() {
        cancellable = viewModel?.$reviews
            .receive(on: DispatchQueue.main)
            .sink { [weak self] values in
                self?.tableView.reloadData()
            }
    }
}

// MARK: UITableView Methods
extension YelpDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return viewModel?.reviews.count ?? 0
            
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: YelpTableViewCell.reuseIdentifier,
                                                           for: indexPath) as? YelpTableViewCell
            else { return UITableViewCell()}
            
            cell.selectionStyle = .none
            cell.willDisplayDetails = true
            cell.model = viewModel?.yelpBusinessModel
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: YelpReviewViewCell.reuseIdentifier,
                                                           for: indexPath) as? YelpReviewViewCell
            else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            cell.model = viewModel?.reviews[indexPath.row]
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
