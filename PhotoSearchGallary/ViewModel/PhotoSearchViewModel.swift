//
//  PhotoSearchViewModel.swift
//  PhotoSearchGallary
//
//  Created by Geetha on 25/02/22.
//

import Foundation
import Combine


protocol PhotoSearchViewModelType {
    var stateBinding: Published<ViewState>.Publisher { get }
    var photoDetailsCount:Int { get }
    var photoDetails:[PhotoDetail] { get }
    func search(request: Request)
}

final class PhotoSearchViewModel: PhotoSearchViewModelType {
    
    var stateBinding: Published<ViewState>.Publisher{ $state }
    
    private let serviceManager:Servicable
    private var cancellables:Set<AnyCancellable> = Set()
    
    @Published  var state: ViewState = .none
    
    var photoDetails:[PhotoDetail] = []
    
    var photoDetailsCount: Int {
        return photoDetails.count
    }
    
    init(serviceManager:Servicable) {
        self.serviceManager = serviceManager
    }
    
    func search(request: Request) {
        
        state = ViewState.loading
        let publisher = serviceManager.doApiCall(apiRequest: request)
        
        let cancalable = publisher.sink { [weak self ]completion in
            switch completion {
            case .finished:
                break
            case .failure(_):
                self?.photoDetails = []
                self?.state = ViewState.error("Network Not Availale")
            }
        } receiveValue: { [weak self] images in
            self?.photoDetails = images
            self?.state = ViewState.finishedLoading
        }
        self.cancellables.insert(cancalable)
    }
    
    
    deinit {
        cancellables.forEach { cancellable in
            cancellable.cancel()
        }
    }
}
