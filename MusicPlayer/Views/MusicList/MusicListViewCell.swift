//
//  MusicListViewCell.swift
//  MusicPlayer
//
//  Created by Nanda Wisnu Tampan on 20/09/21.
//

import Api
import UIKit
import Kingfisher

class MusicListViewCell: UITableViewCell {
    // MARK: - Properties
    var isPlaying = false
    
    lazy var songNameLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.boldSystemFont(ofSize: 14)
        view.textColor = .black
        view.numberOfLines = 0
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var artistNameLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "HelveticaNeue", size: 14)
        view.textColor = .black
        view.numberOfLines = 0
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var albumNameLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "HelveticaNeue", size: 12)
        view.textColor = .black
        view.numberOfLines = 0
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var albumImage: UIImageView = {
       let view = UIImageView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 2
        view.contentMode = .scaleAspectFill
        view.kf.indicatorType = .activity
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var soundWaveIcon: UIImageView = {
       let view = UIImageView()
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "ic_soundwave")
        
        return view
    }()
    
    var imageURL: String? {
        didSet {
            guard let url = imageURL else { return }
            albumImage.loadAlbumArtwork(resource: url)
        }
    }
    
    var item: Music? {
        didSet {
            guard let item = item else { return }
            setItem(item)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        soundWaveIcon.isHidden = true
        isHidden = false
        isSelected = false
        isHighlighted = false
    }
}

extension MusicListViewCell {
    // MARK: - UI Setup
    /// Set UI layout and constraints
    private func setupUI() {
        backgroundColor = .white
        
        let bgView = UIView()
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.addSubview(albumImage)
        bgView.addSubview(songNameLabel)
        bgView.addSubview(artistNameLabel)
        bgView.addSubview(albumNameLabel)
        bgView.addSubview(soundWaveIcon)
        bgView.backgroundColor = UIColor.lightGray
        
        contentView.addSubview(bgView)
        
        let padding: CGFloat = 10
        NSLayoutConstraint.activate([
            // album image artwork constraints
            albumImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            albumImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            albumImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            albumImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            albumImage.widthAnchor.constraint(equalToConstant: 80),
            albumImage.heightAnchor.constraint(equalToConstant: 80),
            
            // song name label constraints
            songNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            songNameLabel.leadingAnchor.constraint(equalTo: albumImage.trailingAnchor, constant: padding),
            
            // artist name label constraints
            artistNameLabel.topAnchor.constraint(equalTo: songNameLabel.bottomAnchor, constant: padding),
            artistNameLabel.leadingAnchor.constraint(equalTo: albumImage.trailingAnchor, constant: padding),
            
            // album name label constraints
            albumNameLabel.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor, constant: padding),
            albumNameLabel.leadingAnchor.constraint(equalTo: albumImage.trailingAnchor, constant: padding),
            albumNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            
            // soundwave icon
            soundWaveIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            soundWaveIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            soundWaveIcon.widthAnchor.constraint(equalToConstant: 50),
            soundWaveIcon.heightAnchor.constraint(equalToConstant: 30),
            
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: albumImage.bottomAnchor, constant: padding)
        ])
    }
    
    private func setItem(_ music: Music) {
        songNameLabel.text = music.trackName
        artistNameLabel.text = music.artistName
        albumNameLabel.text = music.collectionName
        soundWaveIcon.isHidden = !isPlaying
        
        if let url = music.artworkUrl60 {
            albumImage.loadAlbumArtwork(resource: url)
            albumImage.center = center
        }
    }
}
