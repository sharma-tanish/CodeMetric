import SwiftUI
import Charts

struct ComplexityVisualizer: View {
    @Binding var sourceCode: String
    @State private var score: String = ""
    @State private var scores: [Int] = []
    @State private var showVisualisation = false
    
    let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 50 / 255, green: 52 / 255, blue: 54 / 255), // Dracula theme
            Color.black]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    var body: some View {
        ZStack {
            backgroundGradient.ignoresSafeArea(.all)
            VStack {
                Button("Code Score") {
                    calculateScore()
                }
                .padding()
                .background(Color.clear)
                .foregroundColor(.white)
                .cornerRadius(30)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.white, lineWidth: 1)
                )
                .padding(.horizontal)
                .padding(.vertical,50)
                if showVisualisation {
                    Text("Efficiency Score - \(scores[0])\nSyntactical Accuracy Score - \(scores[1])\nCleanCode Score - \(scores[2])")
                        .foregroundStyle(.green)
                        .padding().overlay(RoundedRectangle(cornerRadius:15).stroke(Color.white,lineWidth: 1))
                }
            }
            .sheet(isPresented: $showVisualisation) {
                CodeScoreVisualizer(
                    efficiencyScore: Double(scores[0]),
                    syntacticalAccuracyScore: Double(scores[1]),
                    cleanlinessScore: Double(scores[2])
                )
            }
        }
    }
    
    func calculateScore() {
        Task {
            
            if !sourceCode.isEmpty{
                score = await generateCodeScore(code: sourceCode)
                scores = extractFirstThreeNumbers(from: score)
                if !scores.isEmpty && scores.count == 3 {
                    DispatchQueue.main.async {
                        showVisualisation = true
                    }
                }
            }
        }
    }
}

// Preview


