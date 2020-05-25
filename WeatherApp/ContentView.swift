//
//  ContentView.swift
//  WeatherApp
//
//  Created by Harshit Gajjar on 5/24/20.
//  Copyright © 2020 ThinkX. All rights reserved.
//

import SwiftUI
import CoreLocation
import SwiftyJSON

struct ContentView: View {
    @EnvironmentObject var locationmanager : LocationManager
    var body: some View {
        ZStack {
            Image("background")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
    
            (locationmanager.weather != nil && !locationmanager.forecast.isEmpty) ? HomeView() : nil
        }.onAppear(){
            self.locationmanager.startUpdating()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
