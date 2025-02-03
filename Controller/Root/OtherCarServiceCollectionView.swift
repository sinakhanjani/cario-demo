//
//  OtherCarServiceCollectionView.swift
//  Cario
//
//  Created by Sinakhanjani on 7/28/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class OtherCarServiceCollectionView: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var serviceElement: ServiceElement?
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItem = LoginService.instance.carioInit?.services[1].service.count ?? 0
        return numberOfItem + 1    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OTHER_CAR_SERVICE_COLLECTION_VIEW_CELL, for: indexPath) as! CarServiceCollectionViewCell
        if let services = LoginService.instance.carioInit?.services[1].service {
            if indexPath.row <= services.count - 1 {
                let service = services[indexPath.row]
                cell.configureCell(name: service.name, detail: service.description, badgeNumber: nil)
                let imageURL = "http://app.cario.ir" + service.image
                if service.serviceType == "banner" {
                    if let _ = URL.init(string: service.target) {
                        cell.bannerImageView.loadImageUsingCache(withUrl: imageURL)
                        cell.bannerImageView.alpha = 1.0
                    }
                } else {
                    cell.imageView.loadImageUsingCache(withUrl: imageURL)
                }
            } else {
                cell.configureCell(name: "پیشنهـاد سرویس", detail: "سرویس مورد نیاز خود را پیشنهاد کنید", badgeNumber: nil)
                // cell.imageView.image == *
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColumns: CGFloat = 3
        let padding: CGFloat = 15
        if let services = LoginService.instance.carioInit?.services[1].service {
            if indexPath.row <= services.count - 1 {
                let service = services[indexPath.row]
                return sizeForItemAt(serviceElement: service, numberOfColumns: numberOfColumns, padding: padding)
            }
        }
        let spaceBetweenCells: CGFloat = 20
        let cellDimention = ((UIScreen.main.bounds.width - padding) - (numberOfColumns - 1) * spaceBetweenCells) / numberOfColumns
        return CGSize(width: cellDimention, height: cellDimention * 1.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        if let services = LoginService.instance.carioInit?.services[1].service {
            if index <= services.count - 1 {
                let serviceElement = services[index]
                self.serviceElement = serviceElement
            } else {
                serviceElement = nil
            }
        }
        NotificationCenter.default.post(name: SELECTED_OTHER_CAR_SERVICE_ELEMENT, object: nil)
    }
    
    // Method Helper
    func sizeForItemAt(serviceElement: ServiceElement, numberOfColumns: CGFloat, padding: CGFloat) -> CGSize {
        let spanCount = Int(serviceElement.spanCount)!
        var spaceBetweenCells: CGFloat = 0
        switch spanCount {
        case 2:
            spaceBetweenCells = 10
            let cellDimention = ((UIScreen.main.bounds.width - padding) - (numberOfColumns - 1) * spaceBetweenCells) / numberOfColumns
            return CGSize.init(width: cellDimention * 2, height: cellDimention * 1.2)
        case 3:
            spaceBetweenCells = 10
            let cellDimention = ((UIScreen.main.bounds.width - padding) - (numberOfColumns - 1) * spaceBetweenCells) / numberOfColumns
            return CGSize.init(width: cellDimention * 3, height: cellDimention * 1.2)
        default:
            spaceBetweenCells = 20
            let cellDimention = ((UIScreen.main.bounds.width - padding) - (numberOfColumns - 1) * spaceBetweenCells) / numberOfColumns
            return CGSize(width: cellDimention, height: cellDimention * 1.2)
        }
    }
    
    
}
