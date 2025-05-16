import SwiftUI

struct CoinsShop: View {
    @AppStorage("currentLevel") var currentLevel: Int = 0
    @State private var showMap = false
    @State private var showGame = false
    @State private var showPopup = false // Show pop-up when credit card button is pressed
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 🔹 الخلفية
                Image("menu_background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                // 🔹 الأيقونات أعلى يسار الشاشة
                VStack {
                    HStack {
                        Button(action: {
                            showPopup.toggle() // Show the pop-up when the credit card button is pressed
                        }) {
                            Image(systemName: "wallet.bifold.fill")
                                .resizable()
                                .frame(width: 30, height: 20)
                                .padding(10)
                                .background(.ultraThinMaterial)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }

                        Button(action: {}) {
                            Image(systemName: "speaker.wave.2.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding(10)
                                .background(.ultraThinMaterial)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }

                        Spacer()
                    }
                    .padding([.leading, .top], 20)

                    Spacer()
                }

                // 🔹 صورة بياتو + الأزرار تحتها
                VStack(spacing: 10) { // 🔽 قللنا المسافة من 30 إلى 10
                    Spacer()

                    Image("piato")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300)

                    HStack(spacing: 40) {
                        // زر Map
                        Button(action: { showMap = true }) {
                            Text("Map")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(.ultraThinMaterial)
                                .cornerRadius(10)
                                
                        }

                        // زر Play
                        Button(action: {
                            if currentLevel == 0 {
                                showMap = true
                            } else {
                                showGame = true
                            }
                        }) {
                            Text("Play")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(.ultraThinMaterial)
                                .cornerRadius(10)
                                
                        }

                        // زر Learn
                        Button(action: {
                            // لاحقًا
                        }) {
                            Text("Learn")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(.ultraThinMaterial)
                                .cornerRadius(10)
                                
                        }
                    }

                    Spacer()
                }
                
                // 🔹 Pop-up view when the credit card button is pressed
                if showPopup {
                    VStack {
                        Spacer()

                        VStack(spacing: 20) {
                            HStack {
                                Button(action: {
                                    showPopup.toggle() // Close pop-up
                                }) {
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .frame(width: 15, height: 15) // حجم الأيقونة "xmark" أصغر
                                        .foregroundColor(.white) // اللون الأبيض للأيقونة
                                        .background(
                                            Circle() // استخدام دائرة خلفية
                                                .fill(Color.black.opacity(0.3)) // تعبئة الدائرة باللون الأسود الشفاف
                                                .frame(width: 40, height: 40) // حجم أصغر للدائرة
                                        )
                                        .overlay(
                                            Circle() // دائرة حول الأيقونة
                                                .stroke(Color.c3, lineWidth: 3) // إضافة ستروك باللون السماوي
                                                .frame(width: 40, height: 40) // نفس حجم الدائرة لضمان التناسق
                                        )
                                        .shadow(color: Color.white.opacity(0.9), radius: 10, x: 0, y: 0) // إضافة الظل الأبيض مع تعديل الشفافية والاتجاه
                                }


                                .padding(.top, 5) // التأكد من وجود المسافة من الأعلى
                            }

                            .padding(.trailing, 650) // إضافة padding من اليسار لجعل الزر قريب من الحافة

                            // Horizontal layout for purchase options
                            HStack(spacing: 70) {
                                // First coin option (300)
                                VStack {
                                    Text("300")
                                        .font(.title)
                                        .bold()
                                        .foregroundColor(.white)
                                        .offset(y: -10)
                                    Image("Coins")
                                        .resizable()
                                        .frame(width: 100, height: 100) // نفس حجم الصورة في كل خيار
                                        .offset(y: -10) // رفع الصورة قليلاً للأعلى
                                 // رفع النص قليلاً للأعلى
                                    Button(action: {
                                        // Handle purchase
                                    }) {
                                        HStack(spacing: 5) {
                                            Image("riyal")
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                            Text("5.99")
                                                .font(.body)
                                                .foregroundColor(.white)
                                        }
                                        .frame(width: 150, height: 50) // تحديد الحجم الموحد لكل الأزرار
                                        .background(Color.black.opacity(0.4))
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color.clear, lineWidth: 0.5)
                                        )
                                        .shadow(color: .white.opacity(0.9), radius: 10, x: 2, y: 2)
                                    }
                                }

                                // Second coin option (150)
                                VStack {
                                    Text("150")
                                        .font(.title)
                                        .bold()
                                        .foregroundColor(.white)
                                        .offset(y: -10)
                                    Image("TwoCoins")
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .offset(y: -10)
                                   
                                    Button(action: {
                                        // Handle purchase
                                    }) {
                                        HStack(spacing: 5) {
                                            Image("riyal")
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                            Text("3.99")
                                                .font(.body)
                                                .foregroundColor(.white)
                                        }
                                        .frame(width: 150, height: 50)
                                        .background(Color.black.opacity(0.4))
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color.clear, lineWidth: 0.5)
                                        )
                                        .shadow(color: .white.opacity(0.9), radius: 10, x: 2, y: 2)
                                    }
                                }

                                // Third coin option (75)
                                VStack {
                                    Text("75")
                                        .font(.title)
                                        .bold()
                                        .foregroundColor(.white)
                                        .offset(y: -9)
                                        .padding(.trailing,10)
                                    Image("Coin")
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .offset(y: -10)
                                        .padding(.leading,25)
                                  
                                    Button(action: {
                                        // Handle purchase
                                    }) {
                                        HStack(spacing: 5) {
                                            Image("riyal")
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                            Text("1.99")
                                                .font(.body)
                                                .foregroundColor(.white)
                                        }
                                        .frame(width: 150, height: 50)
                                        .background(Color.black.opacity(0.4))
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color.clear, lineWidth: 0.5)
                                        )
                                        .shadow(color: .white.opacity(0.9), radius: 10, x: 2, y: 2)
                                    }
                                }
                            }
                            .padding()
                            .cornerRadius(15)
                            .shadow(radius: 10)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(
                            ZStack {
                                // Adding a black background with opacity
                                Color.black.opacity(0.5)
                                    .cornerRadius(20)
                                // Frosted glass effect
                                .background(.ultraThinMaterial)
                            }
                        )
                        .cornerRadius(20)
                        .padding()
                    }
                    .transition(.move(edge: .bottom))
                }

            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $showMap) {
                MapView()
            }
        }
    }
}

struct CoinsShop_Previews: PreviewProvider {
    static var previews: some View {
        CoinsShop()
    }
}

