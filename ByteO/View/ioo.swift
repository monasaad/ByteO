import SwiftUI

struct ioo: View {
    @AppStorage("currentLevel") var currentLevel: Int = 0
    @State private var showMap = false
    @State private var showGame = false
    @State private var showPopup = false // Show pop-up when credit card button is pressed
    
    var body: some View {
        NavigationStack {
            ZStack {
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
                    }
                    .padding([.leading, .top], 20)

                    Spacer()
                }
                // Pop-up view when the credit card button is pressed
                if showPopup {
                    VStack {
                        Spacer()

                        VStack(spacing: 20) {
                         

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
