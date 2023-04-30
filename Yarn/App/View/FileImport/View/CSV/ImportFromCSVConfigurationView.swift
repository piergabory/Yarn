//
//  ImportFromCSVConfigurationView.swift
//  Yarn
//
//  Created by Pierre Gabory on 30/04/2023.
//

import SwiftUI

struct ImportFromCSVConfigurationView: View {
    enum DateFormatStyle: CaseIterable, Identifiable {
        case timestamp, iso8601
        var id: Self { self }
    }
    
    @State
    var latitudeColumnIndex: Int = 0
    
    @State
    var longitudeColumnIndex: Int = 1
    
    @State
    var dateColumnIndex: Int = 2
    
    @State
    var dateStyle: DateFormatStyle = .timestamp

    var body: some View {
        VStack {
            Stepper(value: $latitudeColumnIndex, in: 0...100) {
                Text("Latitude column: \(latitudeColumnIndex)")
            }
            Stepper(value: $longitudeColumnIndex, in: 0...100) {
                Text("Longitude column: \(longitudeColumnIndex)")
            }
            Stepper(value: $dateColumnIndex, in: 0...100) {
                Text("Date column: \(dateColumnIndex)")
            }
            Picker("Date format style: ", selection: $dateStyle) {
                Text("ISO 8601").tag(DateFormatStyle.iso8601)
                Text("Timestamp").tag(DateFormatStyle.timestamp)
            }
        }

    }
}

struct ImportFromCSVConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        ImportFromCSVConfigurationView()
    }
}
