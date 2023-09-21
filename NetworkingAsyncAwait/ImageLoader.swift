//
//  ImageLoader.swift
//  NetworkingAsyncAwait
//
//  Created by Darya Kuliashova on 21/09/2023.
//

import Foundation
import SwiftUI

protocol ImageLoaderProtocol {
    func handleResponse(data: Data?, response: URLResponse?) -> UIImage?
    func downloadWithEscaping(completionHandler: @escaping (_ image: UIImage?, _ error: Error?) -> ())
    func downloadWithAsyncAwait() async throws -> UIImage?
}

final class ImageLoader: ImageLoaderProtocol {
    
    private let url = URL(string: "https://picsum.photos/200")!
    
    func handleResponse(data: Data?, response: URLResponse?) -> UIImage? {
        guard
            let data = data,
            let image = UIImage(data: data),
            let response = response as? HTTPURLResponse,
            200...299 ~= response.statusCode else {
            return nil
        }
        return image
    }
    
    func downloadWithEscaping(completionHandler: @escaping (_ image: UIImage?, _ error: Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            let image = self?.handleResponse(data: data, response: response)
            completionHandler(image, error)
        }
        .resume()
    }
    
    func downloadWithAsyncAwait() async throws -> UIImage? {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            return handleResponse(data: data, response: response)
        } catch {
            throw error
        }
    }
}
