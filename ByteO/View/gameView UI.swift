////
//////  gameScreen.swift
//////  ByteO
//////
//////  Created by atheer alshareef on 06/05/2025.
////
//import SwiftUI
//
//struct InfiniteLetterPicker1: View {
//    private let letters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
//    private let loopCount = 3
//    var allLetters: [String] {
//        Array(repeating: letters, count: loopCount).flatMap { $0 }.map { String($0) }
//    }
//    @Binding var selectedLetter: String
//    @State private var selectedIndex: Int = 0
//    
//  var body: some View {
//        ZStack {
//            // الخلفية الزجاجية لمربع الحرف المختار
//            RoundedRectangle(cornerRadius: 8)
//                .fill(.ultraThinMaterial)
//                .frame(width: 30, height: 30)
//                .shadow(color: .white.opacity(0.1), radius: 2, x: 0, y: 1)
//            
//
//            Picker("", selection: $selectedIndex) {
//                ForEach(0..<allLetters.count, id: \.self) { i in
//                    Text(allLetters[i])
//                        .font(.title2)
//                        .frame(width: 40, height: 40)
//                }
//            }
//            .pickerStyle(WheelPickerStyle())
//            .frame(width: 50, height: 120)
//            .clipped()
//            .onAppear {
//                if let centerIndex = allLetters.firstIndex(of: selectedLetter) {
//                    selectedIndex = 26 + centerIndex % 26
//                }
//            }
//            .onChange(of: selectedIndex) { newValue in
//                selectedLetter = allLetters[newValue % 26]
//                if newValue <= 1 || newValue >= allLetters.count - 2 {
//                    selectedIndex = 26 + (newValue % 26)
//                }
//            }
//        }
//    }
//}
//
////
////// MARK: - واجهة اللعبة الرئيسية
//struct DecryptionGameView1: View {
//    @State private var message = "Vhh brx lq Doydk!"
//    @State private var key = 3
//    @State private var slots = ["A", "A", "A", "A", "A"]
//    @State private var showWalletPopup = false
//    @State private var showAttemptsPopup = false
//    @State private var showExitPopup = false
//    @State private var showWinPopup = false
//    @State private var showLosePopup = false
//    @State private var showHintPopup = false
//    @State private var animationOffset: CGFloat = -500
//    @State private var navigateToMainMenu = false
//    @Environment(\.presentationMode) var presentationMode
//    @Environment(\.dismiss) var dismiss
//    let correctWord = "AAAAA" // هذي تروح صفحه ثانيه
//   
//    
// var body: some View {
//        NavigationView {
//            ZStack {
//                Color.black.opacity(0.6)
//                    .edgesIgnoringSafeArea(.all)
//                    .blur(radius: showHintPopup ? 5 : 0) // ← تأثير الـ Blur
//                    .animation(.easeInOut, value: showHintPopup)
//                
//                Image("bg")
//                    .resizable()
//                    .edgesIgnoringSafeArea(.all)
//                
//                VStack(spacing: 5) {
//                    
//                    Button(action: {
//                    showExitPopup = true
//                  }) {
//                    Image(systemName: "chevron.backward.circle.fill")
//                          .font(.title)
//                          .foregroundColor(.purple)
//                          .frame(width: 50, height: 50)
//                          .background(Color.white.opacity(0.15))
//                          .clipShape(Circle())
//                                      }
//                .alert("هل تريد الخروج من اللعبة؟", isPresented: $showExitPopup) {
//                    Button("نعم", role: .destructive) {
//                     navigateToMainMenu = true
//                       }
//                    Button("إلغاء", role: .cancel) {}
//                       }
//       // ✅ NavigationLink للتنقل عند الضغط على نعم
//                  NavigationLink("", destination: MainMenuView(), isActive: $navigateToMainMenu)
//                    
//                    
//                    // 🟢 زر المحفظة (النقاط أو الرصيد)
//                    Button(action: {
//                        showWalletPopup = true
//                    }) {
//                        HStack {
//                            Image(systemName: "wallet.bifold.fill")
//                                .foregroundColor(.white)
//                            Text("200")
//                                .foregroundColor(.white)
//                                .font(.headline)
//                        }
//                        .padding(8)
//                        .background(Color.white.opacity(0.15))
//                        .cornerRadius(12)
//                    }
//                    .alert("رصيدك الحالي هو: 200 نقطة", isPresented: $showWalletPopup) {
//                        Button("موافق", role: .cancel) {}
//                    }
//                    
//                    // 🟡 زر المحاولات
//                    Button(action: {
//                        showAttemptsPopup = true
//                    }) {
//                        HStack {
//                            Image(systemName: "pawprint.fill")
//                                .foregroundColor(.white)
//                            Text("3x")
//                                .foregroundColor(.white)
//                                .font(.headline)
//                        }
//                        .padding(8)
//                        .background(Color.white.opacity(0.15))
//                        .cornerRadius(12)
//                    }
//                    .alert("لديك 3 محاولات متبقية", isPresented: $showAttemptsPopup) {
//                        Button("موافق", role: .cancel) {}
//                    }
//                }
//                .padding(.leading, -410) // ← مسافة من اليسار لتظهر بشكل جيد
//                .padding(.bottom, 180) // ← مسافة من الأعلى
//                
//                
//                HStack(alignment: .top, spacing: -40) {
//                    // 🔶 معلومات المهمة
//                    ZStack {
//                        // الخلفية الزجاجية مع الإضاءة الخفيفة
//                        //   الخلفية الزجاجية مع الإضاءة الخفيفة
//                        RoundedRectangle(cornerRadius: 20)
//                            .fill(.ultraThinMaterial)
//                            .overlay(RoundedRectangle(cornerRadius: 20)
//                                .stroke(Color.c2.opacity(0.8), lineWidth: 1.8) // ← حواف متوهجة
//                            )
//                            .shadow(color: Color.cyan.opacity(0.3), radius: 10, x: 0, y: 5) // ← تأثير الشادو
//                        
//                        // ✅ النصوص داخل المربع
//                        VStack(alignment: .leading, spacing: 5) {
//                            Text("Mission 1 — King Abdullah Financial District")
//                                .font(.system(size: 18, weight: .bold, design: .monospaced))
//                                .foregroundColor(.white)
//                            
//                            Text("Encrypted messages : \(message)")
//                                .font(.system(size: 16, design: .monospaced))
//                                .foregroundColor(.white.opacity(0.9))
//                            
//                            Text("the Key : \(key)")
//                                .font(.system(size: 16, design: .monospaced))
//                                .foregroundColor(.white.opacity(0.9))
//                        }
//                        .padding()
//                        .offset(x: animationOffset) // ← هنا يتم التحكم بالأنميشن
//                        .onAppear {
//                            withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.5)) {
//                                animationOffset = 0 // ← يبدأ التحريك عند الدخول
//                            }
//                        }
//                        .frame(width: 500, height: 100)
//                        
//                        // ✅ زر التلميحات داخل الـ ZStack
//                        Button(action: {
//                            showHintPopup = true
//                        }) {
//                            ZStack {
//                                Circle()
//                                    .fill(Color.c2)
//                                    .frame(width: 50, height: 50)
//                                Image(systemName: "lightbulb.fill")
//                                    .font(.title)
//                                    .frame(width: 50, height: 50)
//                                    .foregroundColor(.white)
//                            }
//                        }
//                        .padding(.leading, -320) // ← يتحكم في مكان الأيقونة
//                        .padding(.bottom, 50)    // ← يرفع الأيقونة للأعلى
//                        .transition(.move(edge: .bottom)) // ← الأنميشن هنا
//                        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: showHintPopup)
//                    }
//                    .frame(width: 500, height: 130)
//                    
//                    // 🔵 صورة الروبوت
//                    Image("robot_zero")
//                        .resizable()
//                        .frame(width: 200, height: 200)
//                        .padding(.leading, -20) // ← مسافة سالبة لتقريبه أكثر
//                        .offset(x: animationOffset) // ← هنا يتم التحكم بالأنميشن
//                        .onAppear {
//                            withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.5)) {
//                                animationOffset = 0 // ← يبدأ التحريك عند الدخول
//                            }
//                        }
//                }
//                .frame(maxWidth: .infinity, alignment: .trailing)
//                .padding(.trailing, -40)
//                .padding(.bottom, 140)
//                
//                // ✅ Popup عند الضغط على Hint
//                .alert("💡 تلميح المهمة", isPresented: $showHintPopup) {
//                    Button("موافق") {}
//                } message: {
//                    Text("حاول فك الشيفرة باستخدام المفتاح المعطى، كل حرف مشفر بثلاث خطوات للأمام.")
//                }
//                
//                
//                
//                VStack(spacing: -15) {
//                    // ✅ مربع النص الخاص بالحروف
//                    Text(slots.joined())
//                        .font(.system(size: 20, weight: .medium, design: .rounded))
//                        .foregroundColor(.white.opacity(0.8))
//                        .padding()
//                        .frame(maxWidth: 250)
//                        .background(.ultraThinMaterial)
//                        .cornerRadius(12)
//                    
//                    // ✅ الرولات التفاعلية
//                    HStack(alignment: .top, spacing: 5) {
//                        ForEach(slots.indices, id: \.self) { index in
//                            InfiniteLetterPicker(selectedLetter: $slots[index])
//                            
//                            
//                        }
//                    }
//                    
//                    // ✅ زر التحقق
//                    Button("Submit") {
//                        let result = slots.joined()
//                        
//                        if result == correctWord {
//                            showWinPopup = true
//                        } else {
//                            showLosePopup = true
//                        }
//                    }
//                    .padding()
//                    .background(Color.purple.opacity(0.7))
//                    .foregroundColor(.white)
//                    .cornerRadius(12)
//                    .padding(.leading, 500)
//                    
//                }
//                .padding(.top, 150)
//                
//            }
//            
//            // ✅ Popup الفوز
//            .alert("🎉 مبروك! فزت!", isPresented: $showWinPopup) {
//                Button("استمرار") {
//                    // هنا يمكنك نقل اللاعب إلى مرحلة أخرى أو إعطاؤه نقاط
//                }
//            } message: {
//                Text("لقد قمت بفك الشيفرة بشكل صحيح!")
//            }
//            
//            // ✅ Popup الخسارة
//            .alert("❌ للأسف، الكلمة غير صحيحة", isPresented: $showLosePopup) {
//                Button("حاول مجددًا", role: .cancel) {
//                    // يعيد المحاولة، لا يحتاج فعل شيء هنا
//                }
//            }
//            .navigationBarBackButtonHidden(true)
//            
//                .navigationBarHidden(true)
//        }
//        
//    }
//}
//
//#Preview {
//    DecryptionGameView1()
//}
//
