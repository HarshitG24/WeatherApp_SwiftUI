//
//  HomeView.swift
//  WeatherApp
//
//  Created by Harshit Gajjar on 5/24/20.
//  Copyright © 2020 ThinkX. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var locationmanager : LocationManager
    @State var searchClicked: Bool = false
    @State var city: String = ""
    var body: some View {
        VStack(alignment: .center){
            
//            HStack{
//                Spacer()
//                searchClicked ? TextField("Enter city", text: $city)
//                                .frame(height: 40)
//                               .background(Color.white)
//                    .padding(.horizontal)
//
//                    : nil
//                Button(action:{
//
//                    if(self.searchClicked){
//                        self.locationmanager.fetchLocation(city: self.city)
//                    }
//                    self.searchClicked = !self.searchClicked
//                }){
//                    Image("search")
//                   .resizable()
//                   .frame(width: 20, height: 20, alignment: .center)
//                }
//            }.padding([.trailing, .top], 20)
            
           
                Text("\(locationmanager.weather!.name)")
                    .foregroundColor(Color.white)
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                    .frame(width: UIScreen.main.bounds.width, alignment: .center)
            
            
            Spacer()
            Text("\(locationmanager.weather!.description)")
                .foregroundColor(Color.white)
                .font(.system(size: 40))
                .fontWeight(.bold)
                .offset(x: 0, y: -20)
            
            Text("\(locationmanager.weather!.temperature)")
            .foregroundColor(Color.white)
            .font(.system(size: 70))
            .fontWeight(.heavy)
            .offset(x: 0, y: -20)
            
            VStack{
                dayData(text: "Feels like \(locationmanager.weather!.feelslike)")
                dayData(text: "Humidity \(locationmanager.weather!.humidity)")
                dayData(text: "Max \(locationmanager.weather!.maxtemp)")
               // dayData(text: "Min \(locationmanager.weather!.mintemp)")
            }.padding(.top, 10)
            .offset(x: 0, y: -20)
            
            Spacer()
            
            HStack{
                forecastDay(forecast: locationmanager.forecast[0])
                Spacer()
                forecastDay(forecast: locationmanager.forecast[1])
                Spacer()
                forecastDay(forecast: locationmanager.forecast[2])
            }.padding()
            
        }.frame(width: UIScreen.main.bounds.width)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct dayData: View{
    var text: String
    var body: some View{
        Text(text)
            .foregroundColor(Color.white)
            .font(.system(size: 16))
            .fontWeight(.bold)
            .padding(.top, 1)
    }
}

struct forecastDay: View{
    var forecast: Forecast
    var body: some View{
        return VStack{
            Text("\(forecast.day)").foregroundColor(Color.white)
                .font(.system(size: 20))
                .fontWeight(.medium)
            Image(forecast.imageName)
                .resizable()
                .frame(width: 60, height: 60, alignment: .center)
            Text("\(forecast.temperature)").foregroundColor(Color.white)
            .font(.system(size: 20))
            .fontWeight(.medium)
        }
    }
}

