//
//  ConvertToPDF.swift
//  AmaniUI
//
//  Created by Bedri Doğan on 10.10.2024.
//

import Foundation
import UIKit

func toPDF(images: [UIImage], withFilename filename: String) -> URL? {
       guard !images.isEmpty else {
           print("No images to convert to PDF.")
           return nil
       }
       
       let pdfPageFrame = CGRect(origin: .zero, size: CGSize(width: 595.2, height: 842.0))
       let pdfRenderer = UIGraphicsPDFRenderer(bounds: pdfPageFrame)

       let pdfData = pdfRenderer.pdfData { (context) in
           for image in images {
               context.beginPage()
               image.draw(in: pdfPageFrame)
           }
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
