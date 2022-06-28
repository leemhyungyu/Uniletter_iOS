//
//  HomeView.swift
//  Uniletter
//
//  Created by 권오준 on 2022/06/27.
//

import UIKit
import SnapKit

class HomeView: UIView {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let margin: CGFloat = 20
        let itemSpacing: CGFloat = 12
        
        let width = (UIScreen.main.bounds.width - margin * 2 - itemSpacing) / 2
        let height = width * 2
        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HomeCell.self, forCellWithReuseIdentifier: HomeCell.identifier)
        
        return collectionView
    }()
    
    lazy var gradientView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    lazy var writeButton: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setLayout()
    }
    
    func addViews() {
        [collectionView, gradientView].forEach { addSubview($0) }
    }
    
    func setLayout() {
        collectionView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
            $0.left.right.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        gradientView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(100)
        }
    }
}
