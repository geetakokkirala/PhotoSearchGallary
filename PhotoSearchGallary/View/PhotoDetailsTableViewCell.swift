//
//  PhotoDetailsTableViewCell.swift
//  PhotoSearchGallary
//
//  Created by Geetha on 25/02/22.
//

import Foundation
import UIKit

class PhotoDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var flickImage: UIImageView!
    
    @IBOutlet weak var imgDesc: UILabel!
    
    func setData(_ photoDetail: PhotoDetail) {
        imgDesc.text = photoDetail.title
        let url = URL(string: photoDetail.url)
       // flickImage.kf.setImage(with:url)
    }

}
