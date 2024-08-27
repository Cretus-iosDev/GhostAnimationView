import SwiftUI

struct GhostShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Head (semi-circle)
        path.addArc(
            center: CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.4),
            radius: rect.width * 0.4,
            startAngle: .degrees(180),
            endAngle: .degrees(0),
            clockwise: false
        )

        // Body (curved bottom)
        path.addLine(to: CGPoint(x: rect.maxX * 0.8, y: rect.maxY * 0.8))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX * 0.2, y: rect.maxY * 0.8),
            control: CGPoint(x: rect.midX, y: rect.maxY * 1.1)
        )
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.2, y: rect.minY + rect.height * 0.4))

        // Eyes (circles)
        let eyeRadius = rect.width * 0.05
        path.addEllipse(in: CGRect(x: rect.midX - eyeRadius * 2, y: rect.midY - eyeRadius, width: eyeRadius * 2, height: eyeRadius * 2))
        path.addEllipse(in: CGRect(x: rect.midX + eyeRadius * 0.5, y: rect.midY - eyeRadius, width: eyeRadius * 2, height: eyeRadius * 2))

        return path
    }
}

struct GhostAnimationView: View {
    @State private var floatUp = false
    @State private var flickerColor = false
    @State private var showText = false

    var body: some View {
        ZStack {
            // Flickering background color
            Color(flickerColor ? .black : .red)
                .animation(
                    Animation.easeInOut(duration: 0.2)
                        .repeatForever(autoreverses: true),
                    value: flickerColor
                )
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    flickerColor.toggle()
                }

            VStack {
                GhostShape()
                    .fill(Color.white)
                    .overlay(
                        GhostShape()
                            .stroke(Color.black, lineWidth: 3)
                    )
                    .frame(width: 150, height: 200)
                    .shadow(radius: 10)
                    .offset(y: floatUp ? -20 : 20)
                    .animation(
                        Animation.easeInOut(duration: 2.0)
                            .repeatForever(autoreverses: true),
                        value: floatUp
                    )
                    .onAppear {
                        floatUp.toggle()
                    }

                // Animated Text
                Text("I'm a bad guy...")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .opacity(showText ? 1 : 0)
                    .scaleEffect(showText ? 1.1 : 0.9)
                    .animation(
                        Animation.easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true),
                        value: showText
                    )
                    .onAppear {
                        showText.toggle()
                    }
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        GhostAnimationView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
