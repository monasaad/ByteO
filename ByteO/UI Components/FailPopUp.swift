////  FailPopUp.swift
////  ByteO
////  Created by Shatha Almukhaild on 18/11/1446 AH.
//

import SwiftUI
import SwiftData
// ✅ FailPopup الجديد بشكل القط مع النجوم والمتجر


struct FailPopup: View {
    @Binding var isPresented: Bool
    var attemptsRemaining: Int
    var onRetry: () -> Void
    var onWait: () -> Void
    var onBuyCoins: () -> Void
    var navigateToMainMenu: () -> Void

    var body: some View {
        if isPresented {
            ZStack {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)

              VStack(spacing: 20) {
                    // ⭐ النجوم المرتبطة بعدد المحاولات
                    HStack(spacing: 15) {
                        ForEach(0..<3, id: \.self) { i in
                            Image(systemName: i < attemptsRemaining ? "star.fill" : "star")
                                .foregroundColor(i < attemptsRemaining ? .yellow : .gray)
                                .shadow(radius: i < attemptsRemaining ? 4 : 0)
                                .font(.system(size: i == 1 ? 45 : 30)) // نجمة وسطى أكبر
                                .shadow(radius: 1)
                                .offset(y: i == 0 ? 20 : (i == 1 ? 0 : 20)) // نجمتين جانبيتين منخفضين أكثر من الوسطى
                                .offset(x: i == 0 ? -10 : (i == 2 ? 10 : 0))
                        }
                    }.offset(y: 20)
                    .padding(.bottom, 5)

                    // 🐱 صورة القطة والبنر
                    ZStack {
                        Image("cat_avatar")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 140, height: 140)

                        Image("YellowBanner")
                            .resizable()
                            .frame(width: 160, height: 38)
                            .offset(y: 60)

                        Text("FAILED !")
                            .font(.headline)
                            .foregroundColor(.white)
                            .offset(y: 55)
                    } .offset(y: 10)

                    // 🐾 المحاولات
                  VStack{
                      HStack(spacing: 0) {
                          ForEach(0..<3, id: \.self) { i in
                              Image(systemName: i < attemptsRemaining ? "pawprint.fill" : "pawprint")
                                  .resizable()
                                  .frame(width: 20, height: 17)
                                  .foregroundColor(i < attemptsRemaining ? .white : .white)
                              
                                  .frame(width: 30)
                          }
                      }
                      .frame(width: 120, height: 30)
                      .background(Color.black.opacity(0.6))
                      .cornerRadius(10)
                      .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white.opacity(0.2), lineWidth: 0.2)
                      )
                      .shadow(color: Color.white.opacity(0.9), radius: 10, x: 2, y: 2)
                      .offset(y: 15)
                      
                      // 📦 أزرار الخيارات
                      HStack(spacing: 20) {
                          Button(action: navigateToMainMenu) {
                              Image(systemName: "xmark")
                              // .font(.system(size: 20))
                                  .foregroundColor(.white)
                                  .frame(width: 50, height: 40)
                                  .background(Color.black.opacity(0.6))
                                  .cornerRadius(10)
                                  .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white.opacity(0.2), lineWidth: 0.2)
                                  )
                                  .shadow(color: Color.white.opacity(0.9), radius: 10, x: 2, y: 2)
                              
                          }
                          
                          Button(action: {
                              if attemptsRemaining > 0 {
                                  isPresented = false
                                  onRetry()
                              } else {
                                  onBuyCoins()
                              }
                          }) {
                              Image(systemName: "arrow.clockwise")
                                  .foregroundColor(.white)
                                  .frame(width: 50, height: 40)
                                  .background(Color.black.opacity(0.6))
                                  .cornerRadius(10)
                                  .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white.opacity(0.2), lineWidth: 0.2)
                                  )
                                  .shadow(color: Color.white.opacity(0.9), radius: 10, x: 2, y: 2)
                              
                          }
                      }.offset(y: 5)
                      .padding(.top, 10)}.offset(y: -10)
                }
                .padding()
                .frame(width: 330, height: 330)
                .background(
                    ZStack{
                        Color.black.opacity(0.5)
                            .cornerRadius(20)
                            .background(.ultraThinMaterial)
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.3),lineWidth: 0.3)
                            .shadow(color: Color.blue.opacity(0.3), radius: 50, x: 10, y: 10)
                    }
                    )
                .cornerRadius(20)
                .padding()
            }
        }
    }
}
