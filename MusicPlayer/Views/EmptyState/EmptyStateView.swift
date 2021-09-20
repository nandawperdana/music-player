//
//  EmptyStateView.swift
//  MusicPlayer
//
//  Created by Nanda Wisnu Tampan on 20/09/21.
//

import UIKit

class EmptyStateView: UIView {
    lazy var emoticonLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "HelveticaNeue", size: 80)
        view.text = "🥱"
        view.textColor = .black
        view.numberOfLines = 0
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var subTitleLabel: UILabel = {
        let view = UILabel()
        view.text = MusicPlayerConstant.initialText
        view.font = UIFont(name: "HelveticaNeue", size: 16)
        view.textColor = .black
        view.numberOfLines = 2
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
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
    
    public func setLabel(text: String, emoticon: String) {
        subTitleLabel.text = text
        emoticonLabel.text = emoticon
    }
    
    private func setupView() {
        backgroundColor = .white
        
        let bgView = UIView()
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.addSubview(emoticonLabel)
        bgView.addSubview(subTitleLabel)
        bgView.layer.cornerRadius = 5
        bgView.backgroundColor = UIColor.lightGray
        
        addSubview(bgView)
        
        let padding: CGFloat = 10
        NSLayoutConstraint.activate([
            // emoticon constraints
            emoticonLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emoticonLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            // subtitle constraints
            subTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            subTitleLabel.topAnchor.constraint(equalTo: emoticonLabel.bottomAnchor, constant: padding)
        ])
    }
}
