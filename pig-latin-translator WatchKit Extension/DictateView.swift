//
//  ContentView.swift
//  pig-latin-translator WatchKit Extension
//
//  Created by Simon Italia on 12/12/21.
//

import SwiftUI
import Foundation

struct DictateView: View {
    
     @State private var capturedText = ""
   
    var body: some View {
        
        VStack {
            Image(systemName: "mic.circle")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 125, maxHeight: 125, alignment: .center)
                
            Text("Tap to Translate")
                .padding(10)
            
        }
            .onTapGesture {
                presentInputController()
            }
    }
    
    private func presentInputController() {
        presentInputController(withSuggestions: []) { result in
            guard !result.isEmpty else { return }
            
            
            // handle result from input controller
            print(result)
            print(result.getPigLatinString())
        }
    }
}

extension View {
    typealias StringCompletion = (String) -> Void
    
    func presentInputController(withSuggestions suggestions: [String], completion: @escaping StringCompletion) {
        WKExtension.shared()
            .visibleInterfaceController?
            .presentTextInputController(withSuggestions: suggestions, allowedInputMode: .plain, completion: { result in
                guard let result = result as? [String], let firstElement = result.first else {
                    completion("")
                    return
            }
                
                completion(firstElement)
            })
    }
}

extension String {
    
    func getPigLatinString() -> String {
        
        //convert text to string array
        let textArray = self.lowercased().components(separatedBy: " ")
        
        let vowels = ["a", "e", "i", "o", "u", "y"]
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
                        
                    // if we hit a vowel, break
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

struct DictateView_Previews: PreviewProvider {
    static var previews: some View {
        DictateView()
    }
}
