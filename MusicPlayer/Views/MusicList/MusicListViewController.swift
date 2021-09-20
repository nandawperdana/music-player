//
//  MusicListViewController.swift
//  MusicPlayer
//
//  Created by Nanda Wisnu Tampan on 20/09/21.
//

import Api
import UIKit
import AVFAudio
import AVFoundation
import Alamofire

public class MusicListViewController: UIViewController {
    
    // MARK: - Private Properties
    var response: MusicResponse!
    var request: DataRequest?
    private var requestState: RequestState = .ready
    private var screenState: ScreenState = .emptyState
    
    /// audio
    var avPlayer: AVPlayer?
    var isPlayerShown = false
    var isPaused = false
    var playingMusic: Music?
    
    let musicAdapter = MusicListViewAdapter()
    
    // MARK: - UI Properties
    var safeArea: UILayoutGuide!
    let screenWidth = UIScreen.main.bounds.size.width
    let padding: CGFloat = 10
    let avPlayerHeight: CGFloat = 100
    
    /// Used as searchResultsController of SearchController
    var searchResultsController: UIViewController? = nil
    lazy var searchController: UISearchController = UISearchController(searchResultsController: searchResultsController)
    
    lazy var audioPlayerView: AudioPlayerView = {
        let view: AudioPlayerView = AudioPlayerView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var musicTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.register(MusicListViewCell.self, forCellReuseIdentifier: musicAdapter.identifier)
        view.backgroundColor = .white
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.delegate = musicAdapter.self
        view.dataSource = musicAdapter
        view.separatorStyle = .singleLine
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.color = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var emptyStateView: EmptyStateView = {
        let view: EmptyStateView = EmptyStateView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(self.didPlayToEnd), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setSearchBarOnNavigation(searchBarDelegate: self,
                                 placeholder: "Find music here ...")
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    // MARK: - Actions
    func play(_ music: Music) {
        do {
            let musicURL = URL(string: music.previewUrl!)
            let playerItem: AVPlayerItem = AVPlayerItem(url: musicURL!)
            avPlayer = AVPlayer(playerItem: playerItem)
            avPlayer?.playImmediately(atRate: 1.0)
            setScreenState(.playState)
        } catch {
            showErrorMessage("Error while playing music.")
            setScreenState(.emptyState)
        }
        
        if let index = musicAdapter.musics.firstIndex(where: { $0.trackId == music.trackId }) {
            let indexPath = IndexPath(item: index, section: .zero)
            let cell = musicTableView.cellForRow(at: indexPath) as! MusicListViewCell
            cell.isPlaying = true
            musicTableView.beginUpdates()
            musicTableView.reloadRows(at: [indexPath], with: .automatic)
            musicTableView.endUpdates()
        }
    }
    
    @objc func didPlayToEnd() {
        if let avPlayer = avPlayer {
            avPlayer.seek(to: CMTimeMakeWithSeconds(0, preferredTimescale: 1))
            audioPlayerView.setupPlayButton()
        }
    }
    
    func fetchMusic(keyword: String) {
        guard requestState != .loading else { return }
        guard Connectivity.isConnectedToInternet else {
            emptyStateView.setLabel(text: MusicPlayerConstant.notFoundText,
                                    emoticon: "😔")
            setScreenState(.emptyState)
            return
        }
        requestState = .loading
        setScreenState(.loadingState)
        request = MusicService.getSearchMusic(
            query: keyword,
            limit: Constant.limit,
            onSuccess: { [weak self] response in
                guard let ws = self else { return }
                ws.response = response
                ws.requestState = .success
                ws.showMusic(response.results)
            },
            onFailure: { [weak self] error in
                guard let ws = self else { return }
                ws.requestState = .error
                ws.showErrorMessage(error.message)
            }
        ).call()
    }
    
    private func showMusic(_ musics: [Music]) {
        if musics.count <= 0 {
            emptyStateView.setLabel(text: MusicPlayerConstant.notFoundText,
                                    emoticon: "😔")
            setScreenState(.emptyState)
        } else {
            musicAdapter.musics = musics
            musicTableView.reloadData()
            setScreenState(.fillState)
        }
    }
    
    func showErrorMessage(_ errorMessage: String) {
        emptyStateView.setLabel(text: errorMessage,
                                emoticon: "😔")
        setScreenState(.emptyState)
    }
    
    private func togglePlayAndPause() {
        if isPaused {
            avPlayer?.pause()
            audioPlayerView.setupPlayButton()
        } else {
            avPlayer?.play()
            audioPlayerView.setupPauseButton()
        }
    }
}

// MARK: - UI Setup
extension MusicListViewController {
    private func setupUI() {
        musicAdapter.delegate = self
        
        safeArea = view.layoutMarginsGuide
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        view.backgroundColor = .white
        view.addSubview(musicTableView)
        view.addSubview(audioPlayerView)
        view.addSubview(loadingView)
        view.addSubview(emptyStateView)
        
        NSLayoutConstraint.activate([
            // music list
            musicTableView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: padding),
            musicTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            musicTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            musicTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
            
            // audio player view
            audioPlayerView.topAnchor.constraint(equalTo: musicTableView.bottomAnchor),
            audioPlayerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            audioPlayerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            audioPlayerView.heightAnchor.constraint(equalToConstant: avPlayerHeight),
            audioPlayerView.widthAnchor.constraint(equalToConstant: screenWidth),
            
            // loading view
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.widthAnchor.constraint(equalToConstant: 50),
            loadingView.heightAnchor.constraint(equalToConstant: 50),
            
            // empty state view
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // adding drop shadow on audio player view
        audioPlayerView.layer.shadowColor = UIColor.black.cgColor
        audioPlayerView.layer.shadowOpacity = 1
        audioPlayerView.layer.shadowOffset = .zero
        audioPlayerView.layer.shadowRadius = 2
        audioPlayerView.layer.shouldRasterize = true
        audioPlayerView.layer.rasterizationScale = UIScreen.main.scale
        
        // set initial views
        emptyStateView.setLabel(text: MusicPlayerConstant.initialText,
                                emoticon: "🥱")
        setScreenState(.emptyState)
    }
    
    private func setScreenState(_ state: ScreenState) {
        switch state {
        case .emptyState:
            emptyStateView.isHidden = false
            loadingView.isHidden = true
            musicTableView.isHidden = true
            audioPlayerView.isHidden = true
            loadingView.stopAnimating()
            
            musicTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding).isActive = true
        case .loadingState:
            emptyStateView.isHidden = true
            loadingView.isHidden = false
            musicTableView.isHidden = true
            audioPlayerView.isHidden = true
            loadingView.startAnimating()
            
            musicTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding).isActive = true
        case .fillState:
            emptyStateView.isHidden = true
            loadingView.isHidden = true
            musicTableView.isHidden = false
            audioPlayerView.isHidden = true
            loadingView.stopAnimating()
            
            musicTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding).isActive = true
        case .playState:
            emptyStateView.isHidden = true
            loadingView.isHidden = true
            musicTableView.isHidden = false
            audioPlayerView.isHidden = false
            loadingView.stopAnimating()
            
            musicTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(padding + avPlayerHeight)).isActive = true
        }
        
        if isPlayerShown {
            audioPlayerView.isHidden = false
            musicTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(padding + avPlayerHeight)).isActive = true
        }
        view.layoutSubviews()
        view.layoutIfNeeded()
    }
}

// MARK: - Delegates
extension MusicListViewController: AudioPlayerViewDelegate {
    func playPauseButton() {
        isPaused = !isPaused
        togglePlayAndPause()
    }
}

extension MusicListViewController: MusicListViewAdapterDelegate {
    func didTap(_ item: Music) {
        audioPlayerView.setupPauseButton()
        play(item)
    }
}

extension MusicListViewController: UISearchBarDelegate {
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchController.searchBar.text?.count ?? 0 > 3 {
            let keyword = searchController.searchBar.text ?? ""
            fetchMusic(keyword: keyword)
        }
    }
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchController.searchResultsController?.view.isHidden = false
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchController.searchResultsController?.view.isHidden = false
    }
}

/// Setup search bar
extension MusicListViewController {
    /// Return nearest BaseNavigationViewController
    final var navBar: UINavigationController? {
        return navigationController
    }
    
    /// Set SearchBar on NavigationBar
    /// If you dont set delegate expicitly, your UISearchResultController would be automatically assigned as `UISearchControllerDelegate`, `UISearchBarDelegate` and `UISearchResultsUpdating` delegate
    ///
    /// - Parameters:
    ///   - delegate: You may put `UISearchControllerDelegate`, `UISearchBarDelegate` and/or `UISearchResultsUpdating here and will be automatically assigned`
    ///   - placeholder: Search Bar text placeholder
    func setSearchBarOnNavigation(searchBarDelegate: Any? = nil,
                                  searchResultsUpdating: Any? = nil,
                                  searchControllerDelegate: Any? = nil,
                                  placeholder: String = "Search") {
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            navigationItem.titleView = searchController.searchBar
        }
        searchController.searchBar.placeholder = placeholder
        
        if #available(iOS 11.0, *) {
            navBar?.navigationBar.prefersLargeTitles = true
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            searchController.hidesNavigationBarDuringPresentation = false
            navigationItem.titleView = searchController.searchBar
        }
                
        if #available(iOS 9.1, *) {
            searchController.obscuresBackgroundDuringPresentation = false
        } else {
            searchController.dimsBackgroundDuringPresentation = false
        }
        definesPresentationContext = true
        
        setDelegate(searchBarDelegate: searchController.searchResultsController,
                    searchResultsUpdating: searchController.searchResultsController,
                    searchControllerDelegate: searchController.searchResultsController)

        setDelegate(searchBarDelegate: searchBarDelegate,
                    searchResultsUpdating: searchResultsUpdating,
                    searchControllerDelegate: searchControllerDelegate)
    }
    
    private func setDelegate(searchBarDelegate: Any?,
                             searchResultsUpdating: Any?,
                             searchControllerDelegate: Any?) {
        if let delegate = searchBarDelegate as? UISearchBarDelegate {
            searchController.searchBar.delegate = delegate
        }
        if let delegate = searchControllerDelegate as? UISearchControllerDelegate {
            searchController.delegate = delegate
        }
        if let delegate = searchResultsUpdating as? UISearchResultsUpdating {
            searchController.searchResultsUpdater = delegate
        }
    }
}
