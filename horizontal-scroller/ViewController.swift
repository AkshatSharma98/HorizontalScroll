//
//  ViewController.swift
//  horizontal-scroller
//
//  Created by Akshat Sharma on 12/02/22.
//

import UIKit

class ViewController: UIViewController {
    
    let reuseId = "myCell"
    let cellWidth: CGFloat = 300
    let extraPad: CGFloat = 85/2
    
    let collectionView: UICollectionView = {
        let flowLayout = SnappingCollectionViewLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        let view = UICollectionView(frame: .zero,
                                    collectionViewLayout: flowLayout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.decelerationRate = UIScrollView.DecelerationRate.fast
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setData()
    }
    
    func setupViews() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: extraPad, bottom: 0, right: extraPad)
    }
    
    func setData() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(MyCell.self, forCellWithReuseIdentifier: reuseId)
        let indexPath = IndexPath(row: 0, section: 0)
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: indexPath,
                                             at: .centeredHorizontally,
                                             animated: false)
            if indexPath.row == 0 {
                let cell = self.collectionView.cellForItem(at: indexPath) as? MyCell
                cell?.containerView.transform = .identity
            }
        }
    }
    
    func checkOffsetValue(scrollView: UIScrollView) {
        let xOffset = scrollView.contentOffset.x + extraPad
        let curIndex = Int(xOffset/cellWidth)
        let nextIndex = curIndex + 1
        let offsetInCurrentContext = xOffset - CGFloat(curIndex) * cellWidth
        
        let value = (((offsetInCurrentContext / cellWidth) * 100 ) * 0.2 ) / 100

        let currentCell = collectionView.cellForItem(at: IndexPath(row: curIndex, section: 0)) as? MyCell
        let nextCell = collectionView.cellForItem(at: IndexPath(row: nextIndex, section: 0)) as? MyCell
        
        currentCell?.containerView.transform = CGAffineTransform(scaleX: 1 - value, y: 1 - value)
        nextCell?.containerView.transform = CGAffineTransform(scaleX: 0.8 + value, y: 0.8 + value)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let color = indexPath.row % 2 == 0 ? UIColor.black : UIColor.blue
        let view = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as? MyCell
        view?.containerView.backgroundColor = color
        view?.containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        let imageName = indexPath.row % 2 == 0 ? "cris" : "cris2"
        view?.imageView.image = UIImage(named: imageName)
        return view!
    }
}

extension ViewController: UICollectionViewDelegate {
    
    
}

extension ViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        checkOffsetValue(scrollView: scrollView)
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: 500)
    }
}

class MyCell: UICollectionViewCell {
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(containerView)
        containerView.addSubview(imageView)
        
        NSLayoutConstraint(item: containerView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: containerView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: containerView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SnappingCollectionViewLayout: UICollectionViewFlowLayout {

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity) }

        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalOffset = proposedContentOffset.x + collectionView.contentInset.left

        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)

        let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect)

        layoutAttributesArray?.forEach({ (layoutAttributes) in
            let itemOffset = layoutAttributes.frame.origin.x
            if fabsf(Float(itemOffset - horizontalOffset)) < fabsf(Float(offsetAdjustment)) {
                offsetAdjustment = itemOffset - horizontalOffset
            }
        })

        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
}
