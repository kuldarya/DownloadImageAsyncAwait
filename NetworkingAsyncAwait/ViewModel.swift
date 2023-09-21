//
//  ViewModel.swift
//  NetworkingAsyncAwait
//
//  Created by Darya Kuliashova on 21/09/2023.
//

import Foundation
import SwiftUI

final class ViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    
    private let imageLoader: ImageLoaderProtocol
    
    init(imageLoader: ImageLoaderProtocol = ImageLoader()) {
        self.imageLoader = imageLoader
    }
    
    func fetchImageWithEscaping() {
        imageLoader.downloadWithEscaping { [weak self] downloadedImage, error in
            if let image = downloadedImage {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
    
    func fetchImageWithAsyncAwait() async {
        let image = try? await imageLoader.downloadWithAsyncAwait()
        
        await MainActor.run {
            self.image = image
        }
    }
}
