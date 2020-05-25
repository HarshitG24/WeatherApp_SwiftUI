//
//  Forecast.swift
//  WeatherApp
//
//  Created by Harshit Gajjar on 5/24/20.
//  Copyright © 2020 ThinkX. All rights reserved.
//

import Foundation

struct Forecast: Identifiable {
    var id : Int
    var day: String
    var imageName: String
    var temperature: String
}
