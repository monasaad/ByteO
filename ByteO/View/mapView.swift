//
//  map.swift
//  ByteO
//
//  Created by atheer alshareef on 10/05/2025.
//

import SwiftUI

struct MapView: View {
    @AppStorage("currentLevel") var currentLevel: Int = 0

    var body: some View {
        ZStack {
            // 🔹 الخلفية
            Image("map_background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()

            HStack {
                // 🔹 صورة الخريطة على اليسار
                Image("metro_map")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                // 🔹 فريم المستويات (تصميم مربع)
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("Olaya")
                            .font(.headline)
                            .foregroundColor(.white)

                        Text(", Level \(currentLevel + 1)")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }

                    ForEach(1..<4) { level in
                        ProgressView("Level \(level)", value: currentLevel >= level ? 1 : 0.3)
                            .progressViewStyle(LinearProgressViewStyle(tint: .mint))
                    }
                }
                .padding()
                .background(Color.black.opacity(0.3))
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.blue, lineWidth: 0.5) // 🔹 حد نيون نحيف جدًا
                )
                .shadow(color: .white.opacity(5), radius: 10, x: 0, y: 4) // 🔹 ظل ناعم وواضح
                .frame(width: 250, height: 250)
            }
        }
    }
}
#Preview {
    MapView()
}
