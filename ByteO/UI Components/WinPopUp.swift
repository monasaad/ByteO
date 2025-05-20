import SwiftUI
struct WinPopup: View {
    @Binding var isPresented: Bool
    var attemptsUsed: Int
    var onContinue: () -> Void
    var onMainMenu: () -> Void

    var filledStars: Int {
        switch attemptsUsed {
        case 0: return 3
        case 1: return 2
        case 2: return 1
        default: return 0
        }
    }

    var body: some View {
        VStack(spacing: 12) {
            // النجوم حسب المحاولات
            HStack(spacing: 0) {
                ForEach(0..<3, id: \.self) { i in
                    Image(systemName: i < filledStars ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                        .font(.system(size: i == 1 ? 45 : 30)) // نجمة وسطى أكبر
                        .shadow(radius: 1)
                        .offset(y: i == 0 ? 20 : (i == 1 ? 0 : 20)) // نجمتين جانبيتين منخفضين أكثر من الوسطى
                        .offset(x: i == 0 ? -10 : (i == 2 ? 10 : 0)) // تنسيق أفقي خفيف عشان توزع القوس
                }
            }
            .offset(y: 60)


            // القطة و البانر
            ZStack {
                Image("background") // استبدل "background" باسم صورة الخلفية
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .clipped()
                    .offset(y: -30)

                Image("cat_avatar")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                  

                Image("YellowBanner")
                    .resizable()
                    .frame(width: 180, height: 40)
                    .offset(y: 60)

                Text("Congratulations")
                    .font(.headline)
                    .foregroundColor(.white)
                    .offset(y: 55)
            }.offset(y: 20)

            // الأزرار
            HStack(spacing: 30) {
                Button(action: {
                    isPresented = false
                    onMainMenu()
                }) {
                    Image(systemName: "arrowshape.turn.up.left.fill")
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
                    isPresented = false
                    onContinue()
                }) {
                    Image(systemName: "chevron.forward.2")
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
            }.offset(y: -70)
            .padding(.top, 10)
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
