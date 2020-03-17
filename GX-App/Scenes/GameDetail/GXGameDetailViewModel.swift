//
//  GXGameDetailViewModel.swift
//  GX-App
//
//  Created by M. Barış ÇİÇEK on 17.03.2020.
//  Copyright © 2020 M. Barış ÇİÇEK. All rights reserved.
//

import Foundation

protocol GXGameDetailViewModelInputs {

}

protocol GXGameDetailViewModelOutputs {
    
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
    
    // MARK: OUTPUTS
    
}
