//
//  UIImageExtension.swift
//  AmaniUI
//
//  Created by Bedri Doğan on 25.09.2024.
//

import UIKit
import CoreImage

extension UIImage {
    /// Converts the `UIImage` to a PDF file and saves it to the given file path.
    /// - Parameter filename: The desired name of the PDF file.
    /// - Returns: The URL of the saved PDF file, or `nil` if saving fails.
    func toPDF(withFilename filename: String) -> URL? {
        let pdfPageFrame = CGRect(origin: .zero, size: self.size)
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: pdfPageFrame)
      
        let pdfData = pdfRenderer.pdfData { (context) in
        
            context.beginPage()
            self.draw(in: pdfPageFrame)
        }
        
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        
        do {
            try pdfData.write(to: fileURL)
            print("PDF başarıyla kaydedildi: \(fileURL)")
            return fileURL
        } catch {
            print("PDF kaydetme hatası: \(error)")
            return nil
        }
    }
    


}


