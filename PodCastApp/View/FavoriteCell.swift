
//
//  FavoriteCell.swift
//  PodCastApp
//
//  Created by Sherif  Wagih on 10/1/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
class FavoriteCell: UICollectionViewCell {
    var podcast:Podcast?{
        didSet{
            if let trackName = podcast?.trackName
            {
                favoriteItemNameLabel.text = trackName
            }
            if let artistName = podcast?.artistName
            {
                favoriteItemAuthroLabel.text = artistName
            }
            if let imageURL = podcast?.artworkUrl600
            {
                favoriteItemImage.sd_setImage(with: URL(string: imageURL), completed: nil)
            }
            
        }
    }
    let favoriteItemImage:UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = #imageLiteral(resourceName: "podCastIcon")
        return image
    }()
    let favoriteItemNameLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Author Name"
        label.font = UIFont.boldSystemFont(ofSize: 19)
        return label
    }()
    let favoriteItemAuthroLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Author Title"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    lazy var containerStackView:UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [favoriteItemImage,favoriteItemNameLabel,favoriteItemAuthroLabel])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    func setupViews(){
        addSubview(containerStackView)
        NSLayoutConstraint.activate([
            favoriteItemImage.heightAnchor.constraint(equalTo: widthAnchor),
           containerStackView.topAnchor.constraint(equalTo: topAnchor),
           containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
           containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
           containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
           
            ])
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
