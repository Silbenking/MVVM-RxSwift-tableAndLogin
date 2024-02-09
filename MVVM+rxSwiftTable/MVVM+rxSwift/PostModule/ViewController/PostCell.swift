//
//  PostCell.swift
//  MVVM+rxSwift
//
//  Created by Сергей Сырбу on 05.02.2024.
//

import UIKit

final class PostCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: "PostCell")
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
