//
//  ViewState.swift
//  PhotoSearchGallary
//
//  Created by MAC on 25/02/22.
//

import Foundation

enum ViewState: Equatable {
    case none
    case loading
    case finishedLoading
    case error(String)
}
