//
//  ContentView.swift
//  NetworkingAsyncAwait
//
//  Created by Darya Kuliashova on 21/09/2023.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchImageWithAsyncAwait()
            }
        }
    }
}

#Preview {
    ContentView()
}
