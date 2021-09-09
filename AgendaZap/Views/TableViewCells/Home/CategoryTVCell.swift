//
//  CategoryTVCell.swift
//  AgendaZap
//
//  Created by Innovative on 31/10/20.
//  Copyright © 2020 AgendaZap. All rights reserved.
//

import UIKit

class CategoryTVCell: UITableViewCell {

    @IBOutlet var viewContainer: UIView!
    @IBOutlet var lblCatName: UILabel!
    @IBOutlet var collSubCategories: UICollectionView! {
        didSet {
            self.collSubCategories.register(UINib(nibName: "SubCategoryCVCell", bundle: nil), forCellWithReuseIdentifier: "SubCategoryCVCell")
        }
    }
    
    @IBOutlet var collSubCategoryHeight: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension CategoryTVCell
{
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forrow row: Int)
    {
        collSubCategories.delegate   = dataSourceDelegate
        collSubCategories.dataSource = dataSourceDelegate
        collSubCategories.tag        = row
        
        collSubCategories.setContentOffset(collSubCategories.contentOffset, animated:false) // Stops collection view if it was scrolling.
        collSubCategories.reloadData()
    }
    
    var collSubCategoriesOffset: CGFloat
    {
        set { collSubCategories.contentOffset.x = newValue }
        get { return collSubCategories.contentOffset.x }
    }
    
}
