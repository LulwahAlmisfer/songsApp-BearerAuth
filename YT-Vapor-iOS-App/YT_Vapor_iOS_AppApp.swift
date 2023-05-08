//
//  YT_Vapor_iOS_AppApp.swift
//  YT-Vapor-iOS-App
//
//  Created by Mikaela Caron on 10/19/21.
//

import SwiftUI

@main
struct YT_Vapor_iOS_AppApp: App {
    
    @StateObject
    var auth = Auth()
    
    
    var body: some Scene {
        
        WindowGroup {
          if auth.isLoggedIn {
           SongList()
             .environmentObject(auth)
           } else {
             LoginView().environmentObject(auth)
           }
         }    }
}
