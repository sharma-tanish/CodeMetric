import SwiftUI



struct OutputView: View {
    @Binding var compiledOutput: String // This variable holds the content to be displayed

    var body: some View {
        ZStack{
            Color.gray.ignoresSafeArea(.all)
            VStack{
                ScrollView {
                    Text(compiledOutput)
                    
                    
                    // Ensure this text view uses compiledOutput
                        .font(.system(.body, design: .monospaced))
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color.black)
                        .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.gray, lineWidth: 1))
                        .padding()
                }
                .cornerRadius(30)
                .navigationTitle("Compiled Output")
                .navigationBarTitleDisplayMode(.inline)
            }
            .background(.white)
        }
    }
}



