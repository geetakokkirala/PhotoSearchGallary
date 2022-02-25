//
//  PhotoSearchViewController.swift
//  PhotoSearchGallary
//
//  Created by Geetha on 25/02/22.
//

import UIKit
import Combine

class PhotoSearchViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var galleryTableView: UITableView!
    private var bindings = Set<AnyCancellable>()
    
    let viewModel:PhotoSearchViewModelType = PhotoSearchViewModel(serviceManager: ServiceManager())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModelState()
        bindSearchTextFieldToViewModel()
    }
    
    private func bindSearchTextFieldToViewModel() {
        searchTextField.textPublisher
             .debounce(for: 0.5, scheduler: RunLoop.main)
             .removeDuplicates()
             .sink { [weak self] in
                 let request = Request(baseUrl: APIEndPoints.baseUrl, path:"", params: ["method":APIEndPoints.photoMethod, "text":$0, "api_key": APIEndPoints.apiKey, "format" : "json", "nojsoncallback" : "1"])

                 self?.viewModel.search(request:request)
             }
             .store(in: &bindings)
    }
    private func bindViewModelState() {
        let cancellable =  viewModel.stateBinding.sink { completion in
            
        } receiveValue: { [weak self] launchState in
            DispatchQueue.main.async {
                self?.updateUI(state: launchState)
            }
        }
        self.bindings.insert(cancellable)
    }
    private func updateUI(state:ViewState) {
        switch state {
        case .none:
            galleryTableView.isHidden = true
        case .loading:
            galleryTableView.isHidden = true
        case .finishedLoading:
            galleryTableView.isHidden = false
            galleryTableView.reloadData()
        case .error(let error):
            galleryTableView.reloadData()
        }
    }

}

extension PhotoSearchViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.photoDetailsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tablecell = tableView.dequeueReusableCell(withIdentifier: "imageCell") as? PhotoDetailsTableViewCell else { return UITableViewCell() }
        
        tablecell.setData(viewModel.photoDetails[indexPath.row])

        
        return tablecell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let saveAction = UIContextualAction(style: .normal, title: "Save") {
            (action, sourceView, completionHandler) in
            let photoDetail = self.viewModel.photoDetails[indexPath.row]
            self.swipeSaveAction(photoDetail, indexpath: indexPath)
            completionHandler(true)
        }
        
        
        saveAction.backgroundColor = UIColor(red: 255/255.0, green: 128.0/255.0, blue: 0.0, alpha: 1.0)
        let shareAction = UIContextualAction(style: .normal, title: "Share") {
            (action, sourceView, completionHandler) in
            self.swipeShareAction(indexpath: indexPath)
            completionHandler(true)
        }
        
        shareAction.backgroundColor = UIColor(red: 28.0/255.0, green: 165.0/255.0, blue: 253.0/255.0, alpha: 1.0)
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [ saveAction, shareAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        
        return swipeConfiguration
        
    }
}
extension PhotoSearchViewController {
    
    func swipeSaveAction( _ imageData : PhotoDetail, indexpath : IndexPath) {
        let cell = galleryTableView.cellForRow(at: indexpath) as? PhotoDetailsTableViewCell
        
        guard let inputImage = cell?.flickImage.image else { return }
        ImageUtility.writeToPhotoAlbum(image: inputImage)
    }
    
    func swipeShareAction(indexpath : IndexPath) {
        let cell = galleryTableView.cellForRow(at: indexpath) as? PhotoDetailsTableViewCell
        guard let inputImage = cell?.flickImage.image else { return }
        let items = [inputImage]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    
}

