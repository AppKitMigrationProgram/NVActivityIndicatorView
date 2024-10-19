//
//  ViewController.swift
//  Example-macOS
//
//  Created by JH on 2024/5/26.
//

import Cocoa
import NVActivityIndicatorView

class ViewController: NSViewController {
    @ViewLoading
    @IBOutlet var collectionView: NSCollectionView

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CollectionViewItem.self, forItemWithIdentifier: .init(String(describing: CollectionViewItem.self)))
        collectionView.enclosingScrollView?.scrollerStyle = .overlay
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }

    let allTypes = NVActivityIndicatorType.allCases.filter { $0 != .blank }
}

extension ViewController: NSCollectionViewDataSource, NSCollectionViewDelegate {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        allTypes.count
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let viewItem = collectionView.makeItem(withIdentifier: .init(String(describing: CollectionViewItem.self)), for: indexPath) as! CollectionViewItem
        viewItem.type = allTypes[indexPath.item]
        return viewItem
    }
}

class CollectionViewItem: NSCollectionViewItem {
    lazy var indicatorView: NVActivityIndicatorView = {
        let indicatorView = NVActivityIndicatorView(frame: .zero, type: type)
        view.addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            indicatorView.topAnchor.constraint(equalTo: view.topAnchor),
            indicatorView.leftAnchor.constraint(equalTo: view.leftAnchor),
            indicatorView.rightAnchor.constraint(equalTo: view.rightAnchor),
            indicatorView.heightAnchor.constraint(equalTo: indicatorView.widthAnchor),
        ])
        indicatorView.layoutSubtreeIfNeeded()
        indicatorView.startAnimating()
        return indicatorView
    }()

    lazy var titleLabel: NSTextField = {
        let titleLabel = NSTextField(labelWithString: "")
        titleLabel.textColor = .labelColor
        titleLabel.font = .systemFont(ofSize: 10)
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: indicatorView.bottomAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        return titleLabel
    }()
    
    var type: NVActivityIndicatorType = .blank {
        didSet {
            indicatorView.type = type
            indicatorView.stopAnimating()
            indicatorView.startAnimating()
            titleLabel.stringValue = type.animationName
        }
    }

    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
