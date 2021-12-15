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
    
    //Text properties
    private let promptImage = "mic.circle"
    private let promptText = " Tap to Translate"
    
    private var promptTextLabel: Text {
        if capturedText.isEmpty {
            return Text(Image(systemName: promptImage)) + Text(promptText)
        }
        
        return Text(capturedText.translateToPigLatin())
    }
    
    var body: some View {

        VStack {
            promptTextLabel
                .lineLimit(nil)
                .padding(10)
                .onTapGesture {
                    presentInputController()
                }
            
            Spacer()
            
            HStack(alignment: .center) {
                Button("Send") {
                print("Message Body: \(pigLatinText)")
                    
                    // format message body payload (pig latin text) as safe url
                    let messageBody = pigLatinText
                    let urlSafeBody = messageBody.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
                    // trigger url
                    if let urlSafeBody = urlSafeBody, let url = NSURL(string: "sms:&body=\(urlSafeBody)") { WKExtension.shared().openSystemURL(url as URL) }

                }
                    .disabled(capturedText.isEmpty)
                
                
                Button("Clear", action: {
                    capturedText.removeAll()
                })
                    .disabled(capturedText.isEmpty)
            }
        }
        .padding()
        .onChange(of: capturedText) { newValue in
            capturedText = newValue
            pigLatinText = capturedText.translateToPigLatin()
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
