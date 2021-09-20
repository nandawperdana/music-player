//
//  MusicListViewAdapter.swift
//  MusicPlayer
//
//  Created by Nanda Wisnu Tampan on 20/09/21.
//

import UIKit
import Api

protocol MusicListViewAdapterDelegate: AnyObject {
    func didTap(_ item: Music)
}

class MusicListViewAdapter: NSObject, UITableViewDelegate, UITableViewDataSource {
    let identifier = "MusicCell"
    
    var musics: [Music] = []
    
    weak var delegate: MusicListViewAdapterDelegate?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MusicListViewCell
        let music = musics[indexPath.row]
        cell.item = music
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let music = musics[indexPath.row]
        delegate?.didTap(music)
    }
}
