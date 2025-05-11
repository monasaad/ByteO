//
////  gameScreen.swift
////  ByteO
////
////  Created by atheer alshareef on 06/05/2025.
//

import SwiftUI

struct InfiniteLetterPicker: View {
    private let letters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    private let loopCount = 3
    
    var allLetters: [String] {
        Array(repeating: letters, count: loopCount).flatMap { $0 }.map { String($0) }
    }
    
    @Binding var selectedLetter: String
    @State private var selectedIndex: Int = 0
    
    var body: some View {
        ZStack {
            // الخلفية الزجاجية لمربع الحرف المختار
            RoundedRectangle(cornerRadius: 8)
                .fill(.ultraThinMaterial)
                .frame(width: 30, height: 30)
                .shadow(color: .white.opacity(0.1), radius: 2, x: 0, y: 1)
            

            Picker("", selection: $selectedIndex) {
                ForEach(0..<allLetters.count, id: \.self) { i in
                    Text(allLetters[i])
                        .font(.title2)
                        .frame(width: 40, height: 40)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(width: 50, height: 120)
            .clipped()
            .onAppear {
                if let centerIndex = allLetters.firstIndex(of: selectedLetter) {
                    selectedIndex = 26 + centerIndex % 26
                }
            }
            .onChange(of: selectedIndex) { newValue in
                selectedLetter = allLetters[newValue % 26]
                if newValue <= 1 || newValue >= allLetters.count - 2 {
                    selectedIndex = 26 + (newValue % 26)
                }
            }
        }
    }
}


// MARK: - واجهة اللعبة الرئيسية
struct DecryptionGameView: View {
    @State private var message = "Vhh brx lq Doydk!"
    @State private var key = 3
    @State private var slots = ["A", "A", "A", "A", "A"]
    @State private var showWalletPopup = false
    @State private var showAttemptsPopup = false
    @State private var showExitPopup = false
    @State private var showWinPopup = false
    @State private var showLosePopup = false
    
    @Environment(\.dismiss) var dismiss
    let correctWord = "AAAAA"
    var body: some View {
        ZStack {
            Image("bg")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 16) {
                
                // 🔴 زر الرجوع للخلف
                Button(action: {
                    showExitPopup = true
                }) {
                    Image(systemName: "chevron.backward.circle.fill")
                        .font(.title)
                        .foregroundColor(.purple)
                        .frame(width: 50, height: 50)
                        .background(Color.white.opacity(0.15))
                        .clipShape(Circle())
                }
                .alert("هل تريد الخروج من اللعبة؟", isPresented: $showExitPopup) {
                    Button("نعم", role: .destructive) {
                        MainMenuView()
                    }
                    Button("إلغاء", role: .cancel) {}
                }
                
                // 🟢 زر المحفظة (النقاط أو الرصيد)
                Button(action: {
                    showWalletPopup = true
                }) {
                    HStack {
                        Image(systemName: "wallet.bifold.fill")
                            .foregroundColor(.white)
                        Text("200")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                    .padding(8)
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(12)
                }
                .alert("رصيدك الحالي هو: 200 نقطة", isPresented: $showWalletPopup) {
                    Button("موافق", role: .cancel) {}
                }
                
                // 🟡 زر المحاولات
                Button(action: {
                    showAttemptsPopup = true
                }) {
                    HStack {
                        Image(systemName: "pawprint.fill")
                            .foregroundColor(.white)
                        Text("3x")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                    .padding(8)
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(12)
                }
                .alert("لديك 3 محاولات متبقية", isPresented: $showAttemptsPopup) {
                    Button("موافق", role: .cancel) {}
                }
            }
            .padding(.leading, -410) // ← مسافة من اليسار لتظهر بشكل جيد
            .padding(.bottom, 180) // ← مسافة من الأعلى
            
            
            
            
            HStack(alignment: .top, spacing: -40) { // ← المسافة السالبة لتقريب الروبوت
                // 🔶 معلومات المهمة
                ZStack {
                    // الخلفية الزجاجية مع الإضاءة الخفيفة
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.c2.opacity(0.8), lineWidth: 1.8) // ← حواف متوهجة
                        )
                        .shadow(color: Color.cyan.opacity(0.3), radius: 10, x: 0, y: 5) // ← تأثير الشادو
                    // 🟡 زر المحاولات
                    Button(action: {
                        showAttemptsPopup = true
                    }) {
                        HStack {
                            Image(systemName: "lightbulb")
                                .font(.title)
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                        }
                        
                        .background(Color.c2)
                        .clipShape(Circle())
                        .padding(.leading, -320)
                        .padding(.bottom, 50)
                    }
                    .alert("لديك 3 محاولات متبقية", isPresented: $showAttemptsPopup) {
                        Button("موافق", role: .cancel) {}
                    }
                    
                    
                    
                    // النصوص داخل المربع
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Mission 1 — King Abdullah Financial District")
                            .font(.system(size: 18, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                        
                        Text("Encrypted messages : \(message)")
                            .font(.system(size: 16, design: .monospaced))
                            .foregroundColor(.white.opacity(0.9))
                        
                        Text("the Key : \(key)")
                            .font(.system(size: 16, design: .monospaced))
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding()
                }
                .frame(width: 500, height: 100)
                
                // 🔵 صورة الروبوت
                Image("robot_zero")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .padding(.leading, -20) // ← مسافة سالبة لتقريبه أكثر
                
                
                
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing, -40)
            .padding(.bottom, 140)
            
            
           
            VStack(spacing: -15) {
                    // ✅ مربع النص الخاص بالحروف
                    Text(slots.joined())
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.8))
                        .padding()
                        .frame(maxWidth: 250)
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                    
                    // ✅ الرولات التفاعلية
                HStack(alignment: .top, spacing: 5) {
                        ForEach(slots.indices, id: \.self) { index in
                            InfiniteLetterPicker(selectedLetter: $slots[index])
                            
                            
                        }
                    }
                    
                    // ✅ زر التحقق
                Button("Submit") {
                        let result = slots.joined()
                        
                        if result == correctWord {
                            showWinPopup = true
                        } else {
                            showLosePopup = true
                        }
                    }
                    .padding()
                    .background(Color.purple.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.leading, 500)

                }
                .padding(.top, 150)
            
        }
        
        // ✅ Popup الفوز
        .alert("🎉 مبروك! فزت!", isPresented: $showWinPopup) {
            Button("استمرار") {
                // هنا يمكنك نقل اللاعب إلى مرحلة أخرى أو إعطاؤه نقاط
            }
        } message: {
            Text("لقد قمت بفك الشيفرة بشكل صحيح!")
        }

        // ✅ Popup الخسارة
        .alert("❌ للأسف، الكلمة غير صحيحة", isPresented: $showLosePopup) {
            Button("حاول مجددًا", role: .cancel) {
                // يعيد المحاولة، لا يحتاج فعل شيء هنا
            }
        }
    }
}
#Preview {
    DecryptionGameView()
}
