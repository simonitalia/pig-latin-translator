//
//  ContentView.swift
//  pig-latin-translator WatchKit Extension
//
//  Created by Simon Italia on 12/12/21.
//

import SwiftUI
import Foundation

struct MainView: View {
    
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
            print(result.translateToPigLatin())
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

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
