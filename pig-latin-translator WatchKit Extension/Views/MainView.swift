//
//  ContentView.swift
//  pig-latin-translator WatchKit Extension
//
//  Created by Simon Italia on 12/12/21.
//

import SwiftUI
import WatchKit
import Foundation

struct MainView: View {
    
    @State private var capturedText = ""
    @State private var pigLatinText = ""
    
    //text and image properties
    private let promptImage = "mic.circle.fill"
    
    private let promptTapImage = "hand.tap.fill"
    private let promptText = " Tap to Translate"
    
    private var promptTextView: Text {
        if capturedText.isEmpty {
            return Text(Image(systemName: promptTapImage)) + Text(promptText)
        }
        
        return Text(capturedText.translateToPigLatin())
    }
    
    //body container
    var body: some View {

        VStack {
            
            // image and text container
            VStack(spacing: 10) {
                if capturedText.isEmpty {
                    Image(systemName: promptImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60, alignment: .center)
                        .foregroundColor(Color.blue)
                }
                
                promptTextView
                    .lineLimit(nil)
            }
            .onTapGesture { presentInputController() }
            
            // message buttons container
            if !capturedText.isEmpty {
                
                Spacer()
                
                HStack {
                    
                    // send message button
                    Button("Send") {

                        // format message body payload (pig latin text) as safe url
                        let messageBody = pigLatinText
                        let urlSafeBody = messageBody.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            
                        // trigger url
                        if let urlSafeBody = urlSafeBody, let url = NSURL(string: "sms:&body=\(urlSafeBody)") { WKExtension.shared().openSystemURL(url as URL) }

                    }
                        .disabled(capturedText.isEmpty)
                        .foregroundColor(.blue)
                    
                    // clear message button
                    Button("Cancel", action: {
                        capturedText.removeAll()
                    })
                        .disabled(capturedText.isEmpty)
                        .foregroundColor(.red)
                }
            }
        }
        .onChange(of: capturedText) { newValue in
            capturedText = newValue
            pigLatinText = capturedText.translateToPigLatin()
            
            #if DEBUG
            print("Message Body: \(pigLatinText)")
            #endif
        }
    }
    
    func presentInputController() {
        WKExtension.shared()
            .visibleInterfaceController?
            .presentTextInputController(withSuggestions: nil, allowedInputMode: .plain, completion: { result in
                
                if let result = result as? [String], let firstElement = result.first {
                    capturedText = firstElement
                }
            })
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
