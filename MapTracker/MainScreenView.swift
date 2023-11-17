//
//  MainScreenView.swift
//  MapTracker
//
//  Created by Andrey Pozdnyakov on 17.11.2023.
//

import SwiftUI

struct MainScreenView: View {
    var body: some View {
        VStack {
            MapView()
//                .frame(width: UIScreen.main.bounds.width*0.9, height: UIScreen.main.bounds.height*0.9)
                .edgesIgnoringSafeArea(.all)
        }
        .padding()
    }
}

#Preview {
    MainScreenView()
}
