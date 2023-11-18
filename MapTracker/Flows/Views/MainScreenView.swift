//
//  MainScreenView.swift
//  MapTracker
//
//  Created by Andrey Pozdnyakov on 17.11.2023.
//

import SwiftUI
import GoogleMaps

struct MainScreenView: View {
    @ObservedObject private var viewModel: MapViewModel
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack {
                    MappView()
                    HStack {
                        Spacer()
                        VStack {
                            Button {
                                viewModel.zoom += 2
                            } label: {
                                Text("+")
                                    .padding()
                                    .background(Color(.white))
                            }
                            .padding(.bottom, 30)
                            Button {
                                viewModel.zoom -= 2
                            } label: {
                                Text("-")
                                    .padding()
                                    .background(Color(.white))
                            }
                        }
                    }
                }
            }
            buildInfoSection()
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    private func buildInfoSection() -> some View {
        VStack(spacing: 0) {
            HStack {
                Text("Бензовоз")
                    .font(.system(size: 20, weight: .semibold))
                Spacer()
            }
            HStack {
                Image("calendar")
                Text("16.08.2023 — 16.08.2023")
                Spacer()
                Image("distance")
                Text("10 км")
                Spacer()
                Image("speed")
                Text("До 98км/ч")
            }
            .font(.system(size: 12))
        }
        .frame(height: 213)
        .padding(.all, 16)
    }
}

#Preview {
    MainScreenView(viewModel: MapViewModel())
}

