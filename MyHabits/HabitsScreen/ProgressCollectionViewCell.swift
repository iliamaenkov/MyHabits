//
//  ProgressCollectionViewCell.swift
//  MyHabits
//
//  Created by Ilya Maenkov on 11.11.2023.
//

import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Все получится!"
        label.font = .SFProTextSemibold_Medium
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
