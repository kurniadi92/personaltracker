//
//  UIImage+Extensionn.swift
//  personaltracker
//
//  Created by kur niadi  on 11/07/22.
//

import Foundation
import UIKit

extension UIImage {
    func saveToDocuments(filename:String) -> URL? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        if let data = self.jpegData(compressionQuality: 1.0) {
            do {
                try data.write(to: fileURL)
                return fileURL
            } catch {
                print("error saving file to documents:", error)
                return nil
            }
        } else {
            return nil
        }
    }
    
    func fetchImage(with imageName: String) -> UIImage? {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        if let path = paths.first {
            let imageURL = URL(fileURLWithPath: path).appendingPathComponent(imageName)
            let data = try! Data(contentsOf: imageURL)
            if let image = UIImage(data: data) {
                return image
            }
        }
        return nil
    }

}
