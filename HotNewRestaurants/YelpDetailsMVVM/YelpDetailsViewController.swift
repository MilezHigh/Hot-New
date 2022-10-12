//
//  YelpDetailsViewController.swift
//  HotNewRestaurants
//
//  Created by Miles Fishman on 10/12/22.
//

import UIKit

class YelpDetailsViewController: UIViewController {
    lazy var tableView: UITableView = {
        let t = UITableView()
        t.delegate = self
        t.dataSource = self
        t.backgroundColor = .clear
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()
    
    var viewModel: YelpDetailsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        registerCells()
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
    }
}

// MARK: UITableView Methods
extension YelpDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 1 : 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: YelpTableViewCell.reuseIdentifier,
                                                           for: indexPath) as? YelpTableViewCell
            else { return UITableViewCell() }
            cell.willDisplayDetails = true
            cell.model = viewModel?.yelpBusinessModel
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: YelpTableViewCell.reuseIdentifier,
                                                           for: indexPath) as? YelpTableViewCell
            else { return UITableViewCell() }
            cell.willDisplayDetails = true
            cell.model = viewModel?.yelpBusinessModel
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let cell = tableView.cellForRow(at: indexPath) as? YelpTableViewCell,
            let model = cell.model
        else { return }
        
        let detailsViewModel = YelpDetailsViewModel(yelpBusinessModel: model)
        
        let detailsController = YelpDetailsViewController()
        detailsController.viewModel = detailsViewModel
        
        navigationController?.pushViewController(detailsController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
