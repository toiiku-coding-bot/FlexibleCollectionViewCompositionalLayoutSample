// Here's some ample code

import UIKit

enum Section: CaseIterable {
    case main
}

class ViewController: UIViewController {
    
    let sampleData = [
        "Mount Everest,8848",
        "K2,8611",
        "Kangchenjunga,8586",
        "Lhotse,8516",
        " Makalu,8485",
        "Cho Oyu,8201",
        "Dhaulagiri,8167",
        "Manaslu,8163",
        "Nanga Parbat,8126",
        "Annapurna,8091",
        "Gasherbrum I,8080",
        "Broad Peak,8051",
        "Gasherbrum II,8035",
        "Shishapangma,8027",
        "Himalchuli,7893",
        "Distaghil Sar,7885",
        "Ngadi Chuli,7871",
        "Nuptse,7861",
        "Khunyang Chhish,7852"
    ]
    
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<Section, String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
    }
    
    // DiffableDataSource 部分
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration
        <LabelCell, String> { (cell, indexPath, string) in
            cell.label.text = string
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: String) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(sampleData)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func configureHierarchy() {
        view.backgroundColor = .systemBackground
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
    }
    
    // ⭐️⭐️⭐️⭐️⭐️ ここ重要!! ⭐️⭐️⭐️⭐️⭐️：CompositionalLayout 部分
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
                                                            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            
            let layoutSize = NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .absolute(32))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: layoutSize.heightDimension),
                                                           subitems: [.init(layoutSize: layoutSize)])
            group.interItemSpacing = .fixed(10)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
            section.interGroupSpacing = 10
            
            return section
        }
        return layout
    }
    
}

// Cell
class LabelCell: UICollectionViewCell {
    static let reuseIdentifier = "label-cell-reuse-identifier"
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    func configure() {
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray2.cgColor
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
