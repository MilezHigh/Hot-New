//
//  YelpReviewCell.swift
//  HotNewRestaurants
//
//  Created by Miles Fishman on 10/12/22.
//

import UIKit

class YelpReviewViewCell: UITableViewCell {
    
    lazy var containerView: UIStackView = {
        let view = UIStackView(frame: contentView.bounds)
        view.distribution = .equalCentering
        view.axis = .vertical
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var contentStackView: UIStackView = {
        let view = UIStackView(frame: contentView.bounds)
        view.distribution = .fillEqually
        view.axis = .horizontal
        return view
    }()
    
    lazy var descriptionLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.numberOfLines = 0
        view.textColor = . black
        view.font = .systemFont(ofSize: 15)
        view.textAlignment = .left
        return view
    }()
    
    lazy var ratingLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.textColor = . black
        view.font = .systemFont(ofSize: 10)
        view.textAlignment = .center
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.textColor = . black
        view.font = .systemFont(ofSize: 10)
        view.textAlignment = .center
        return view
    }()
    
    lazy var timeLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = .systemFont(ofSize: 10)
        view.textColor = . black
        view.textAlignment = .center
        return view
    }()
    
    lazy var userImageContainerView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    lazy var userImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    static var reuseIdentifier: String = "YelpReviewViewCell"
    
    var willDisplayDetails: Bool = false
    
    var model: YelpAPIReviewModel? {
        didSet {
            guard let model = model else { return }
            
            setup()
            
            nameLabel.text = model.user?.name
            ratingLabel.text = "Rating: \(model.rating?.description ?? "")"
            descriptionLabel.text = model.text
            timeLabel.text = model.time_created
            
            userImageView.loadImage(urlString: model.user?.image_url ?? "")
        }
    }
        
    private func setup() {
        separatorInset.left = 0
        backgroundColor = .clear
        
        addSubview(containerView)
        
        containerView.addArrangedSubview(userImageContainerView)
        containerView.addArrangedSubview(descriptionLabel)
        containerView.addArrangedSubview(contentStackView)
        userImageContainerView.addSubview(userImageView)

        [nameLabel, ratingLabel, timeLabel].forEach { label in
            contentStackView.addArrangedSubview(label)
        }
        
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            
            userImageContainerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            
            userImageView.centerYAnchor.constraint(equalTo: userImageContainerView.centerYAnchor),
            userImageView.centerXAnchor.constraint(equalTo: userImageContainerView.centerXAnchor),
            userImageView.heightAnchor.constraint(equalToConstant: 50),
            userImageView.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
}
