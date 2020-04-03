//
//  AblumDetailViewController.swift
//  iTunesTopAlbumViewer
//
//  Created by Nick Hayward on 3/24/20.
//  Copyright © 2020 Nick Hayward. All rights reserved.
//

import Foundation
import UIKit

final class AblumDetailViewController: UIViewController {
    
    private let album: FeedResult
    
    private lazy var mainStack = makeStackView(arrangedSubviews: [albumCoverImageView, albumInfoStackView])
    private lazy var albumCoverImageView = makeAlbumCoverImageView()
    private lazy var albumInfoStackView = makeStackView(arrangedSubviews: [albumNameLabel,
                                                                           artistNameLabel,
                                                                           genreLabel,
                                                                           releaseDateLabel,
                                                                           copyRightLabel])
    private lazy var albumLinkButton = makeAppleLinkButton()
    private lazy var albumNameLabel = makeLabel(with: album.name, textStyle: .largeTitle, weight: .bold)
    private lazy var artistNameLabel = makeLabel(with: album.artistName, textStyle: .title2)
    private lazy var genreLabel = makeLabel(with: album.genres.first?.name ?? "", textStyle: .title3)
    private lazy var releaseDateLabel = makeLabel(with: album.releaseDate, textStyle: .title3)
    private lazy var copyRightLabel = makeLabel(with: album.copyright, textStyle: .footnote, color: .systemGray)
    
    init(with photo: FeedResult, albumCoverImage: UIImage) {
        self.album = photo
        super.init(nibName: nil, bundle: nil)
        self.albumCoverImageView.image = albumCoverImage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setup()
        addSubViews()
        addConstraints()
        setPreferredSize()
    }
    
    func setup() {
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .systemBackground
    }
    
    func addSubViews() {
        view.addSubview(mainStack)
        view.addSubview(albumLinkButton)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            albumLinkButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            albumLinkButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            albumLinkButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    // MARK: Target/Actions
    @objc func openURL() {
        guard let urlString = album.url,
            let url = URL(string: urlString) else { return }
        
        UIApplication.shared.open(url)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setPreferredSize()
    }
    
    private func setPreferredSize() {
        switch traitCollection.verticalSizeClass {
        case .compact:
            mainStack.axis = .horizontal
        default:
            mainStack.axis = .vertical
        }
    }
    
    // MARK: UI Builder
    private func makeLabel(with text: String, comment: String = "", textStyle style: UIFont.TextStyle, weight: UILegibilityWeight = .regular, color: UIColor = .label) -> UILabel {
        let label = UILabel()
        label.text = NSLocalizedString(text, comment: comment)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.textColor = color
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.preferredFont(forTextStyle: style,
                                          compatibleWith: .init(legibilityWeight: weight))
        return label
    }
    
    private func makeAppleLinkButton() -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "Apple Music Link"
        button.setTitle(NSLocalizedString("Open Album in Apple Music", comment: "Open Album URL in Apple Music"), for: .normal)
        button.addTarget(self, action: #selector(openURL), for: .touchUpInside)
        return button
    }
    
    private func makeAlbumCoverImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.accessibilityIdentifier = "Album Cover Image"
        imageView.accessibilityLabel = "Album Cover for \(album.name)"
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        return imageView
    }
    
    private func makeStackView(arrangedSubviews: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }
}
