//
//  GXAlertPresenter.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 17.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import UIKit.UIViewController

protocol GXAlertPresenter {
    func presentInfoAlert(title: String, message: String?, displayTime: TimeInterval)
}

extension GXAlertPresenter where Self: UIViewController {
    func presentInfoAlert(title: String, message: String? = nil, displayTime: TimeInterval = 1) {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: .alert)
        
        present(alertController, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + displayTime) {
                alertController.dismiss(animated: true)
            }
        }
    }
}
