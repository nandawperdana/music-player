//
//  Constant.swift
//  MusicPlayer
//
//  Created by Nanda Wisnu Tampan on 20/09/21.
//

enum ScreenState {
    case emptyState, loadingState, fillState, playState
}

struct Constant {
    // MARK: - URL base path
    static let apiBasePath: String = "https://itunes.apple.com/"
    static let limit = 25
}
