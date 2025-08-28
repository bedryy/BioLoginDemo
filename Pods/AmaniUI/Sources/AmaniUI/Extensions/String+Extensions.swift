//
//  String+Extensions.swift
//  AmaniUI
//
//  Created by Deniz Can on 24.01.2024.
//

import Foundation

extension String {
    func convertDateFormat() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        if let originalDate = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: originalDate)
        } else {
            return nil
        }
    }
    
    func lowercasedFirstLetter() -> String {
        guard let first = first else { return self }
        return String(first).lowercased() + dropFirst()
    }
    

    func extractTextWithinSingleQuotes() -> String? {
        do {
            // Düzenli ifade pattern'i: ‘(.*?)’|\((.*?)\)
            let regex = try NSRegularExpression(pattern: "‘(.*?)’|\\((.*?)\\)", options: [])
            let nsString = self as NSString
            let matches = regex.matches(in: self, options: [], range: NSMakeRange(0, nsString.length))
            
            var results = ""
            
            for match in matches {
                for rangeIndex in 1..<match.numberOfRanges {
                    let range = match.range(at: rangeIndex)
                    if range.location != NSNotFound {
                        let matchedString = nsString.substring(with: range)
                        results.append(matchedString.capitalizedWords())
                    }
                }
            }
            return results
        } catch let error {
            print("Hata oluştu: \(error.localizedDescription)")
            return ""
        }
    }
       func capitalizedWords() -> String {
           return self.lowercased().split(separator: " ").map { $0.capitalized }.joined(separator: " ")
       }
}
