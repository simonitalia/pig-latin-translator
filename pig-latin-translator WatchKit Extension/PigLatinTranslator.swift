//
//  pig_latin_translatorApp.swift
//  pig-latin-translator WatchKit Extension
//
//  Created by Simon Italia on 12/12/21.
//

import SwiftUI

@main
struct PigLatinTranslator: App {
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                DictateView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
