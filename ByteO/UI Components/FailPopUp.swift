//  FailPopUp.swift
//  ByteO
//  Created by Shatha Almukhaild on 18/11/1446 AH.

import SwiftUI


struct FailPopUp: View {
    @AppStorage("currentLevel") var currentLevel: Int = 0
    @State private var showRetryAlert = false

    @Binding var failPopup: Bool // Show pop-up
    @Binding var navigateToMainMenu: Bool
    @State private var showExitPopup = false
    var body: some View {
    
            if failPopup {
                // Pop-up view when the user fail the mission
                    VStack {
                        Spacer()

                        VStack(spacing: 20) {
                            HStack(spacing: 70) {
                                ZStack {
                                    VStack {
                                        HStack(spacing: 5) {
                                            Image(systemName: "star")
                                                .foregroundColor(.yellow)
                                                .font(.system(size: 30))
                                                .rotationEffect(.degrees(-30))

                                            Image(systemName: "star")
                                                .foregroundColor(.yellow)
                                                .font(.system(size: 40))
                                                .rotationEffect(.degrees(0))
                                                .offset(y: -10)

                                            Image(systemName: "star")
                                                .foregroundColor(.yellow)
                                                .font(.system(size: 30))
                                                .rotationEffect(.degrees(30))
                                        }
                                       // .padding(.bottom,15)
                                        Spacer()
                                        ZStack{
                                            Image("cat_avatar")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 150, height: 150)
                                                .frame(width: 500)
                                                .offset(y: -30)

                                            Image("YellowBanner")
                                                .resizable()
                                                .frame(width: 180, height: 40)
                                                .offset(y: 50)
                                            
                                            Text("Failed") // النص الذي سيظهر فوق الصورة
                                                .font(.headline)
                                                .foregroundColor(.white)
                                                .padding()
                                                .background(Color.clear.opacity(0.7)) // خلفية بنية اللون مع شفافية
                                                //.cornerRadius(10)
                                                .offset(y: 45) // تحريك النص فوق الصورة
                                        }
                                        Spacer()
                                        HStack{
                                            Button(action: {
                                                showExitPopup = true

                                            }) {
                                                HStack(spacing: 5) {
                                                    Image("exit")
                                                        .resizable()
                                                        .frame(width: 20, height: 20)
                                                }
                                                .frame(width: 60, height: 50)
                                                .background(Color.black.opacity(0.4))
                                                .cornerRadius(10)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 15)
                                                        .stroke(Color.clear, lineWidth: 0.5)
                                                )
                                                .shadow(color: .white.opacity(0.9), radius: 10, x: 2, y: 2)
                                                .offset(y: -30)
                                            }.alert("هل تريد الخروج من اللعبة؟", isPresented: $showExitPopup) {
                                                Button("نعم", role: .destructive) { navigateToMainMenu = true }
                                                Button("إلغاء", role: .cancel) {}
                                            }
                                            Button(action: {
                                                // Handle purchase
                                                
                                            }) {
                                                HStack(spacing: 5) {
                                                    Image("Replay")
                                                        .resizable()
                                                        .frame(width: 20, height: 23)
                                                }
                                                .frame(width: 60, height: 50)
                                                .background(Color.black.opacity(0.4))
                                                .cornerRadius(10)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 15)
                                                        .stroke(Color.clear, lineWidth: 0.5)
                                                )
                                                .shadow(color: .white.opacity(0.9), radius: 10, x: 2, y: 2)
                                                .offset(y: -30)
                                            }
                                        }

                                    }
                                }
                            }
                            .padding()
                            .cornerRadius(15)
                            .shadow(radius: 10)
                        }
                        .frame(width: 350, height: 350)
                        .background(
                            ZStack {
                                Color.black.opacity(0.5)
                                    .cornerRadius(20)
                                .background(.ultraThinMaterial)
                            }
                        )
                        .cornerRadius(20)
                        .padding()
                    }
                    .transition(.move(edge: .bottom))
                

            }
   
        }
    }


struct FailPopUp_Previews: PreviewProvider {
    static var previews: some View {
        FailPopUp(failPopup:.constant(true) ,navigateToMainMenu: .constant(false))
    }
}
