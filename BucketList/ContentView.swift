//
//  ContentView.swift
//  BucketList
//
//  Created by gülçin çetin on 1.10.2025.
//

import LocalAuthentication
import MapKit
import SwiftUI

struct ContentView: View {
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 56, longitude: -3),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        )
    )
    
    @State private var viewModel = ViewModel()
    
    @State private var mapStyle = ""
    
    var body: some View {

            if viewModel.isUnlocked {
                MapReader { proxy in
                    Map(initialPosition: startPosition) {
                        ForEach(viewModel.locations) { location in
                            Annotation(location.name, coordinate: location.coordinate) {
                                Image(systemName: "star.circle")
                                    .resizable()
                                    .foregroundStyle(.green)
                                    .frame(width: 44, height: 44)
                                    .background(.white)
                                    .clipShape(.circle)
                                
                                    .onLongPressGesture {
                                        viewModel.selectedPlace = location
                                    }
                            }
                        }
                    }.mapStyle(mapStyle == "standard" ? .standard : .hybrid)
                        .sheet(item: $viewModel.selectedPlace) { place in
                            EditView(location: place) {
                                viewModel.update(location: $0)
                            }
                        }
                    
                        .onTapGesture { position in
                            if let coordinate = proxy.convert(position, from: .local) {
                                viewModel.addLocation(at: coordinate)
                        }
                    }
                }
                Button("Standard Map Style") {
                    mapStyle = "standard"
                }
                .padding()
                .background(.green)
                .foregroundStyle(.white)
                .clipShape(.rect(cornerRadius: 50))
                
                Button("Hybrid Map Style") {
                    mapStyle = "hybrid"
                }
                .padding()
                .background(.green)
                .foregroundStyle(.white)
                .clipShape(.rect(cornerRadius: 50))
                
            } else {
                  
                Button("Unlock Places", action: viewModel.authenticate)
                    .padding()
                    .background(.green)
                    .foregroundStyle(.white)
                    .clipShape(.rect(cornerRadius: 50))
        }
    }
}

#Preview {
    ContentView()
}
