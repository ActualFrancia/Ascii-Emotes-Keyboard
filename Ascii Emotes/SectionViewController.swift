//
//  SectionViewController.swift
//  Ascii Emotes
//
//  Created by Kali Francia on 3/12/24.
//

import UIKit

// Emotes, within a section, Selection UICollection
class SectionViewController: UIViewController {
    var textDocumentProxy: UITextDocumentProxy?
    var sectionTitle: String?
    var emotes: [String] = []
    var collectionView: UICollectionView!
    var buttonActions = [UIButton: () -> Void]()
    
    // Style
    let numberOfRows: CGFloat = 4
    let cellWidthPadding: CGFloat = 20
    let verticalPadding: CGFloat = 10
    let horizontalPadding: CGFloat = 10
    let spacing: CGFloat = 7
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    @objc private func dismissView() {
        emotes = []
        dismiss(animated: false, completion: nil)
    }
    
    @objc private func cancelDismissView() {
        // TODO: IMAGE AND COLOR CHANGE
    }
    
    func setupView() {
        // Title
        let titleLabel = UILabel()
        titleLabel.text = sectionTitle
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        // Add constraints for the label
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 10),
        ])
        
        
        loadEmoteSections()
        
        backButton()

    }
    
    func loadEmoteSections() {
        guard let path = Bundle.main.path(forResource: sectionTitle, ofType: "json") else {
            print("ERROR WITH JSON PATH")
            return
        }
        
        let filePath = URL(fileURLWithPath: path)
        
        // Initially hide loading indicator
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .gray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Add a delay of 0.2 seconds for loading leeway
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            // Check if data loading is still in progress
            if activityIndicator.isAnimating {
                activityIndicator.startAnimating()
            }
        }
        
        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let self = self else { return }
            
            do {
                let data = try Data(contentsOf: filePath)
                self.emotes = try JSONDecoder().decode([String].self, from: data)
                
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                    self.setupCollectionView()
                }
            } catch {
                print("ERROR LOADING JSON: \(error)")
                // Handle error, e.g., show an alert
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                }
            }
        }
    }

    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 7
        layout.minimumLineSpacing = 7
        
        // Padding
        layout.sectionInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = .clear
        
        // Bounce
        //collectionView.alwaysBounceVertical = true
        collectionView.alwaysBounceHorizontal = true

        // Clipping for the collection view
        collectionView.clipsToBounds = false
        
        collectionView.register(EmoteCell.self, forCellWithReuseIdentifier: "EmoteCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
              collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
              collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
              collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
              collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
          ])
    }
    
    func backButton() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(systemName: "arrowshape.backward.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)), for: .normal)
        backButton.setImage(UIImage(systemName: "arrowshape.backward.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)), for: .highlighted)
        backButton.tintColor = UIColor(named: "ControlColor")
        
        backButton.translatesAutoresizingMaskIntoConstraints = false

        backButton.addTarget(self, action: #selector(dismissView), for: .touchDown)
        backButton.addTarget(self, action: #selector(cancelDismissView), for: [.touchUpInside, .touchUpOutside, .touchCancel])

        // Add to View
        view.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
        ])
    }
}

// EmoteViewController Extensions
extension SectionViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emotes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmoteCell", for: indexPath) as! EmoteCell
        cell.configure(with: emotes[indexPath.item])
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalVerticalPadding: CGFloat = verticalPadding * 2
        let totalSpacing = spacing * (numberOfRows - 1)
        
        let availableHeight = collectionView.bounds.height - totalVerticalPadding - totalSpacing
        let height = availableHeight / numberOfRows
        
        // Adjusting width based on content
        let width = emotes[indexPath.item].size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0)]).width + cellWidthPadding
        
        return CGSize(width: width, height: height)
    }
}

extension SectionViewController: EmoteCellDelegate {
    func didSelectEmote(emote: String) {
        textDocumentProxy?.insertText(emote)
    }
}

