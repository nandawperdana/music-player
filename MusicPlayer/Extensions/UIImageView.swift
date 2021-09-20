//
//  UIImageView.swift
//  MusicPlayer
//
//  Created by Nanda Wisnu Tampan on 20/09/21.
//

import UIKit
import Kingfisher

extension UIImageView {
    func loadAlbumArtwork(resource: String,
                          placeholder: UIImage? = nil) {
        do {
            let url = try resource.asURL()
            let resource = ImageResource(downloadURL: url)
            kf.setImage(with: resource,
                        placeholder: placeholder,
                        options: [.transition(.fade(0.2)),
                                  .cacheOriginalImage])
        } catch {
            image = placeholder
        }
    }
}
