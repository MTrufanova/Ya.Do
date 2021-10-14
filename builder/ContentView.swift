//
//  ContentView.swift
//  TheApp
//
//  Created by msc on 20.07.2021.
//

import SwiftUI

struct ContentView: View {
    var data: [Human] = HumanList.humans

    var body: some View {
        NavigationView {
            List(data, id: \.id) { human in
                Image(human.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .cornerRadius(5)
                    .padding(.vertical, 4)
                VStack(alignment: .leading, spacing: 5) {
                    Text(human.name)
                        .foregroundColor(Color.black)
                        .fontWeight(.semibold)
                        .font(.system(size: 20))
                    Text(human.date)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .font(.system(size: 20))
                }
            }
            .navigationTitle("Romanovs")
        }


    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
