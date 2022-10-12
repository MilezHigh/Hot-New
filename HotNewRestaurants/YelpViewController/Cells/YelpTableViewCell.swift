//
//  YelpTableViewCell.swift
//  HotNewRestaurants
//
//  Created by Miles Fishman on 10/12/22.
//

import UIKit

class YelpTableViewCell: UITableViewCell {
    
    lazy var containerView: UIStackView = {
        let view = UIStackView(frame: contentView.bounds)
        view.distribution = .fillEqually
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var contentStackView: UIStackView = {
        let view = UIStackView(frame: contentView.bounds)
        view.distribution = .equalSpacing
        view.axis = .vertical
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.numberOfLines = 0
        view.textColor = . black
        view.font = .systemFont(ofSize: 20)
        view.textAlignment = .right
        return view
    }()
    
    lazy var ratingLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.textColor = . black
        view.font = .systemFont(ofSize: 15)
        view.textAlignment = .right
        return view
    }()
    
    lazy var priceLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.textColor = . black
        view.font = .systemFont(ofSize: 15)
        view.textAlignment = .right
        return view
    }()
    
    lazy var distanceLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = .systemFont(ofSize: 15)
        view.textColor = . black
        view.textAlignment = .right
        return view
    }()
    
    lazy var addressLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = .systemFont(ofSize: 15)
        view.textColor = . black
        view.textAlignment = .right
        view.numberOfLines = 0
        return view
    }()
    
    lazy var phoneLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = .systemFont(ofSize: 15)
        view.textColor = . black
        view.textAlignment = .right
        return view
    }()
    
    lazy var businessImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .lightGray
        return view
    }()
        
    static var reuseIdentifier: String = "YelpTableViewCell"
    
    var willDisplayDetails: Bool = false
    
    var model: YelpAPIBusinessModel? {
        didSet {
            guard let model = model else { return }
            
            setup()
            
            nameLabel.text = model.name
            ratingLabel.text = "Rating: \(model.rating?.description ?? "")"
            priceLabel.text = model.price ?? "Price: N/A"
            
            let miles = model.distance?.returnMiles() ?? 0
            distanceLabel.text = "\(miles) mi. away"
            phoneLabel.text = model.phone ?? "Phone: N/A"
            addressLabel.text = model.location?.display_address?.reduce("", {
                $0 + "\($0 == "" ? $0 : ", ")" + $1
            })
            
            businessImageView.loadImage(urlString: model.image_url ?? "")
        }
    }
        
    private func setup() {
        separatorInset.left = 0
        backgroundColor = .clear
        
        addSubview(containerView)
        
        containerView.addArrangedSubview(contentStackView)
        contentStackView.addArrangedSubview(businessImageView)

        [nameLabel, addressLabel, phoneLabel, ratingLabel, priceLabel, distanceLabel].forEach { label in
            contentStackView.addArrangedSubview(label)
        }
        
        addressLabel.isHidden = !willDisplayDetails
        phoneLabel.isHidden = !willDisplayDetails
        distanceLabel.isHidden = willDisplayDetails
        nameLabel.isHidden = willDisplayDetails
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            
            businessImageView.heightAnchor.constraint(equalToConstant: 200),
            nameLabel.heightAnchor.constraint(equalToConstant: 30),
            ratingLabel.heightAnchor.constraint(equalToConstant: 20),
            priceLabel.heightAnchor.constraint(equalToConstant: 20),
            distanceLabel.heightAnchor.constraint(equalToConstant: 20),
            addressLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
            phoneLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
}
