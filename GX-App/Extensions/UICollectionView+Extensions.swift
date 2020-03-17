//
//  UICollectionView+Extensions.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 17.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import UIKit.UICollectionView

extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(cellClass: T.Type) {
        register(cellClass, forCellWithReuseIdentifier: String(describing: cellClass.self))
    }
    
    func register<T: UICollectionViewCell>(xibClass: T.Type) {
        let nib = UINib(nibName: String(describing: xibClass.self), bundle: .init(for: T.self))
        register(nib, forCellWithReuseIdentifier: String(describing: T.self))
    }

    public func dequeue<T: UICollectionViewCell>(cellClass: T.Type, forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(
            withReuseIdentifier: String(describing: cellClass.self), for: indexPath) as? T else {
                fatalError(
                    "Error: cell with id: \(String(describing: cellClass.self)) for indexPath: \(indexPath) is not \(T.self)")
        }
        return cell
    }
    
}
