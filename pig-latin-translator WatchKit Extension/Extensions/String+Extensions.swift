//
//  String+Extensions.swift
//  pig-latin-translator WatchKit Extension
//
//  Created by Simon Italia on 14/12/21.
//

import Foundation

extension String {
    
    func translateToPigLatin() -> String {
        guard !self.isEmpty else { return "" }
        
        //convert text to string array
        let textArray = self.lowercased().components(separatedBy: " ")
        
        let vowels = ["a", "e", "i", "o", "u"]
        let aySuffix = "ay"
        let waySuffix = "way"
        
        var translatedArray = [String]()
        
        textArray.forEach { word in
            
            // get first letter of word as String
            guard let firstCharacter = word.first else { return }
            
            let firstLetter = String(firstCharacter)
            
            //if first letter is a vowel
            
            // if so, append word with "way"
            if vowels.contains(firstLetter) {
                let newWord = word + waySuffix
                translatedArray.append(newWord)
            
            // if not a vowel, iterate word for consonant cluster and move to end
            
            // append with ay
            } else {
                var newWord = word

                for (i, character) in word.enumerated() {
                    
                    //if character is a consonant
                    if !vowels.contains(String(character)) && i != word.count - 1 {
                        
                        // append consonant to end of word
                        newWord.append(character)
                        
                        //remove consonant from start of word
                        if let index = newWord.firstIndex(of: character) {
                            newWord.remove(at: index)
                        }
                        
                    // if we hit a vowel or finl character, break
                    } else {
                        newWord += aySuffix
                        translatedArray.append(newWord)
                        break
                    }
                }
            }
        }
        
        // convert translated string array to string
        return translatedArray.joined(separator: " ")
    }
}
