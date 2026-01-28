//
//  UIImageView+LoadImage.swift
//  BooksApp
//
//  Created by Ekaterina Bastrikina on 22/01/2026.
//

import UIKit

extension UIImageView {
    func loadImage(from url: URL?, placeholder: UIImage? = nil) {
        
        self.image = placeholder
        
        
        guard let url = url else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  let data = data,
                  let downloadedImage = UIImage(data: data),
                  error == nil else { return }
            
            DispatchQueue.main.async {
                self.image = downloadedImage
            }
        }.resume()
    }
}



