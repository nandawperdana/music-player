//
//  AudioPlayerView.swift
//  MusicPlayer
//
//  Created by Nanda Wisnu Tampan on 20/09/21.
//

import UIKit

protocol AudioPlayerViewDelegate: AnyObject {
    func playPauseButton()
}

class AudioPlayerView: UIView {
    let screenWidth = UIScreen.main.bounds.size.width
    weak var delegate: AudioPlayerViewDelegate?
    
    lazy var playPauseButton: UIButton = {
        let view = UIButton()
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Pause", for: .normal)
        view.setImage(UIImage(named: "ic_pause"), for: .normal)
        view.addTarget(self, action: #selector(self.playPauseButtonAction), for: .touchUpInside)
        return view
    }()
    
    // initWithFrame to init view from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    // initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupPlayButton() {
        playPauseButton.setTitle("Play", for: .normal)
        playPauseButton.setImage(UIImage(named: "ic_play"), for: .normal)
    }
    
    func setupPauseButton() {
        playPauseButton.setTitle("Pause", for: .normal)
        playPauseButton.setImage(UIImage(named: "ic_pause"), for: .normal)
    }
    
    private func setupView() {
        backgroundColor = .lightGray
        
        let bgView = UIView()
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.addSubview(playPauseButton)
        
        addSubview(bgView)
        
        let padding: CGFloat = 10
        NSLayoutConstraint.activate([
            // play button
            playPauseButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            playPauseButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            playPauseButton.widthAnchor.constraint(equalToConstant: 50),
            playPauseButton.heightAnchor.constraint(equalToConstant: 50),
            
            bottomAnchor.constraint(greaterThanOrEqualTo: playPauseButton.bottomAnchor, constant: padding)
        ])
    }
    
    @objc func playPauseButtonAction(sender: UIButton!) {
        delegate?.playPauseButton()
        print("play button nih")
    }
}
