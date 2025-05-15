import SwiftUI

struct ioo: View {
    @AppStorage("currentLevel") var currentLevel: Int = 0
    @State private var showMap = false
    @State private var showGame = false
    @State private var showPopup = false // Show pop-up when credit card button is pressed
    
    var body: some View {
        NavigationStack {
            ZStack {
                // الخلفية
                Image("menu_background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                // الأيقونات أعلى يسار الشاشة
                VStack {
                    HStack {
                        Button(action: {
                            showPopup.toggle() // Show the pop-up when the credit card button is pressed
                        }) {
                            Image(systemName: "creditcard.fill")
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

                // صورة بياتو + الأزرار تحتها
                VStack(spacing: 10) {
                    Spacer()

                    Image("piato") // استبدل "piato" بالصورة المناسبة
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

                // Pop-up view when the credit card button is pressed
                if showPopup {
                    VStack {
                        Spacer()

                        VStack(spacing: 20) {
                            HStack {
                                // زر إغلاق "x" في الزاوية العلوية اليمنى
                                Button(action: {
                                    showPopup.toggle() // Close pop-up
                                }) {
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .frame(width: 15, height: 15) // حجم الأيقونة "xmark"
                                        .foregroundColor(.white)
                                        .background(
                                            Circle() // استخدام دائرة خلفية
                                                .fill(Color.black.opacity(0.3)) // تعبئة الدائرة باللون الأسود الشفاف
                                                .frame(width: 40, height: 40) // حجم أصغر للدائرة
                                        )
                                        .overlay(
                                            Circle() // دائرة حول الأيقونة
                                                .stroke(Color.c2, lineWidth: 3) // إضافة ستروك باللون السماوي
                                                .frame(width: 40, height: 40) // نفس حجم الدائرة لضمان التناسق
                                        )
                                        .shadow(color: Color.white.opacity(0.9), radius: 10, x: 0, y: 0) // إضافة الظل الأبيض مع تعديل الشفافية والاتجاه
                                }
                                .padding([.top, .trailing], 20) // تحسين المحاذاة
                                Spacer()
                            }

                            HStack(spacing: 70) {
                                ZStack {
                                    Image("background") // استبدل "background" باسم صورة الخلفية
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 300, height: 300)
                                        .clipped()
                                        .offset(y: -30)
                                 
                                    VStack {
                                        HStack(spacing: 5) {
                                            Image(systemName: "star.fill")
                                                .foregroundColor(.yellow)
                                                .font(.system(size: 30))
                                                .rotationEffect(.degrees(-30))

                                            Image(systemName: "star.fill")
                                                .foregroundColor(.yellow)
                                                .font(.system(size: 40))
                                                .rotationEffect(.degrees(0))
                                                .offset(y: -10)

                                            Image(systemName: "star.fill")
                                                .foregroundColor(.yellow)
                                                .font(.system(size: 30))
                                                .rotationEffect(.degrees(30))
                                        }
                                       // .padding(.bottom,15)
                                        ZStack{
                                            Image("piato")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 200, height: 200)
                                                .frame(width: 500)
                                                .offset(y: -30)

                                            Image("image4")
                                                .resizable()
                                                .frame(width: 180, height: 40)
                                                .offset(y: 50)
                                            
                                            Text("Congratulations") // النص الذي سيظهر فوق الصورة
                                                .font(.headline)
                                                .foregroundColor(.white)
                                                .padding()
                                                .background(Color.clear.opacity(0.7)) // خلفية بنية اللون مع شفافية
                                                //.cornerRadius(10)
                                                .offset(y: 45) // تحريك النص فوق الصورة
                                        }
                                        HStack{
                                            Button(action: {
                                                // Handle purchase
                                            }) {
                                                HStack(spacing: 5) {
                                                    Image("riyal")
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
                                            }
                                            Button(action: {
                                                // Handle purchase
                                            }) {
                                                HStack(spacing: 5) {
                                                    Image("riyal")
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
            .navigationBarHidden(true)
        }
    }
}

struct ioo_Previews: PreviewProvider {
    static var previews: some View {
        ioo()
    }
}
