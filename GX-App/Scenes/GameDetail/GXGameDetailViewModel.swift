//
//  GXGameDetailViewModel.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 17.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import Foundation

protocol GXGameDetailViewModelInputs {
    func viewDidLoaded()
}

protocol GXGameDetailViewModelOutputs {
    func numberOfItems() -> Int
    func layoutItem(for index: Int) -> GXGameDetailTableLayoutItems
}

protocol GXGameDetailViewModelType {
    var inputs: GXGameDetailViewModelInputs { get }
    var outputs: GXGameDetailViewModelOutputs { get set }
}

final class GXGameDetailViewModel: GXGameDetailViewModelType, GXGameDetailViewModelInputs, GXGameDetailViewModelOutputs {
    
    // MARK: VIEWMODEL TYPE
    
    var inputs: GXGameDetailViewModelInputs { return self }
    var outputs: GXGameDetailViewModelOutputs {
        get { return self } set {}
    }
    
    // MARK: INPUTS
    
    func viewDidLoaded() {
        
    }
    
    // MARK: OUTPUTS
    
    func numberOfItems() -> Int {
        return GXGameDetailTableLayoutItems.allCases.count
    }
    
    func layoutItem(for index: Int) -> GXGameDetailTableLayoutItems {
        guard let item = GXGameDetailTableLayoutItems.init(rawValue: index) else {
            fatalError("Error: \(GXGameDetailTableLayoutItems.self) does not contain index: \(index)")
        }
        return item
    }
    
}
