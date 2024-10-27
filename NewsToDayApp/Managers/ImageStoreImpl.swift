//
//  ImageStoreImpl.swift
//  NewsToDayApp
//
//  Created by Келлер Дмитрий on 26.10.2024.
//

import UIKit

protocol ImageStore {
    @discardableResult
    func save(_ image: CGImage, for url: URL) -> CGImage
    func getImage(for url: URL) -> CGImage?
}

final class ImageStoreImpl: ImageStore {
    
    private let cache = NSCache<NSURL, CGImage>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    init() {
        let cacheURLs = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = cacheURLs[0].appendingPathComponent("ImageCache")
        
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
    }
    
    @discardableResult
    func save(_ image: CGImage, for url: URL) -> CGImage {
        let nsURL = url as NSURL
        cache.setObject(image, forKey: nsURL)
        
        // Сохраняем изображение на диск
        let imageURL = cacheDirectory.appendingPathComponent(url.lastPathComponent)
        let uiImage = UIImage(cgImage: image)
        if let data = uiImage.pngData() {
            try? data.write(to: imageURL)
        }
        
        return image
    }
    
    func getImage(for url: URL) -> CGImage? {
        let nsURL = url as NSURL
        
        if let cachedImage = cache.object(forKey: nsURL) {
            return cachedImage
        }
        
        // Загрузка изображения с диска при отсутствии в памяти
        let imageURL = cacheDirectory.appendingPathComponent(url.lastPathComponent)
        if let data = try? Data(contentsOf: imageURL), let uiImage = UIImage(data: data)?.cgImage {
            cache.setObject(uiImage, forKey: nsURL)
            return uiImage
        }
        
        return nil
    }
}
