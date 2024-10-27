//
//  AsyncCachedImage.swift
//  NewsToDayApp
//
//  Created by Келлер Дмитрий on 26.10.2024.
//


import SwiftUI

struct AsyncCachedImage: View {
    let url: URL?
    let placeholder: Image
    @State private var uiImage: UIImage? = nil
    
    private let imageStore: ImageStore = ImageStoreImpl()
    
    var body: some View {
        if let uiImage = uiImage {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
        } else {
            placeholder
                .resizable()
                .aspectRatio(contentMode: .fill)
                .task {
                    await loadImage()
                }
        }
    }
    
    private func loadImage() async {
        guard let url = url else { return }

        if let cachedImage = imageStore.getImage(for: url) {
            uiImage = UIImage(cgImage: cachedImage)
        } else {
            if let (data, _) = try? await URLSession.shared.data(from: url),
               let downloadedImage = UIImage(data: data)?.cgImage {
                uiImage = UIImage(cgImage: downloadedImage)
                imageStore.save(downloadedImage, for: url)
            }
        }
    }
}
