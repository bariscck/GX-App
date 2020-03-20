//
//  UITableView+Extensions.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 17.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import UIKit.UITableView

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableView {
    
    func register<T: UITableViewCell>(cellClass: T.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.identifier)
    }
    
    func register<T: UITableViewCell>(xibClass: T.Type) {
        let nib = UINib(nibName: String(describing: xibClass.self), bundle: .init(for: T.self))
        register(nib, forCellReuseIdentifier: xibClass.identifier)
    }
    
    public func dequeue<T: UITableViewCell>(cellClass: T.Type) -> T? {
        return dequeueReusableCell(withIdentifier: cellClass.identifier) as? T
    }

    public func dequeue<T: UITableViewCell>(cellClass: T.Type, forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(
            withIdentifier: cellClass.identifier, for: indexPath) as? T else {
                fatalError(
                    "Error: cell with id: \(cellClass.identifier) for indexPath: \(indexPath) is not \(T.self)")
        }
        return cell
    }
    
}

extension UITableView {
    
    func emptyMessage(message: String) {

        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: bounds.size)
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        messageLabel.sizeToFit()

        backgroundView = messageLabel
    }
    
    func restore() {
        backgroundView = nil
    }
    
}
