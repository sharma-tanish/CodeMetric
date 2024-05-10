

import SwiftUI


struct ContentView: View {
    @State private var showImageView = false
    @State private var showOutputView = false
    @State private var image: UIImage = UIImage()
    @Binding var recognizedText: String
    @State private var langName = "Language"
    @State private var isLoading = false
    @State private var compiledOutput = ""
    @State private var selectedTab = 1
    @FocusState private var nameIsFocused: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.96, green: 0.96, blue: 0.95, opacity: 1.00) // One Dark Theme Background
                    .ignoresSafeArea()
                    .onTapGesture {
                        // Dismiss keyboard when tapping outside
                        nameIsFocused = false
                    }

                VStack(spacing: 20) {
                    // Header with buttons and language text
                    headerView
                    
                    Spacer()
                    
                    // TextEditor
                    ScrollView {
                        RandomizedTextColorizer(text: $recognizedText)
                            .frame(height: 450)
                            .background(Color(red: 56 / 255, green: 58 / 255, blue: 66 / 255))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(.black, lineWidth: 2))
                            .focused($nameIsFocused)
                            .padding()
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .sheet(isPresented: $showImageView, onDismiss: loadImage) {
                ImagePicker(selectedImage: $image)
            }
            .sheet(isPresented: $showOutputView) {
                OutputView(compiledOutput: $compiledOutput)
            }
        }
    }
    
    var headerView: some View {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(Color(red: 0.71, green: 0.71, blue: 0.72, opacity: 1.00))
            .frame(height: 70)
            .overlay(
                HStack {
                    photoSelectionButton
                    languageNameText
                    Spacer()
                    runButton
                }
            )
            .padding(.top, 50)
    }
    
    var photoSelectionButton: some View {
        Button(action: {
            nameIsFocused = false
            showImageView = true
        }) {
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
                .padding()
                .clipShape(Circle())
        }
        .padding(.leading, 10)
    }
    
    var languageNameText: some View {
        Text(langName)
            .font(.system(size: 18))
            .frame(alignment: .center)
            .foregroundColor(.white)
            .padding(.horizontal)
    }
    
    var runButton: some View {
        Button {
            nameIsFocused = false
            generateReview()
        } label: {
            Image(systemName: "doc.plaintext")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.white)
        }
        .padding(.trailing, 10)
        .padding(.horizontal)
    }
    
    func recognizeLanguage() {
        
        if !recognizedText.isEmpty{
            Task {
                let res = await findProgLangFromCode(code: recognizedText)
                if res.lowercased() != "language unidentified" {
                    self.langName = res
                } else {
                    self.langName = "Language Unidentified"
                }
            }
        }else{
            self.langName = ""
        }
    }
    
    
    func generateReview() {
        recognizeLanguage()
        isLoading = true

        if !recognizedText.isEmpty{
            Task {
                let result = await analyzeSourceCode(code: recognizedText)
                DispatchQueue.main.async {
                    self.compiledOutput = result
                    print(result)
                    
                    isLoading = false
                    
                    if self.compiledOutput != "error", self.compiledOutput != "no response generated", !self.compiledOutput.isEmpty {
                        self.showOutputView = true
                    } else {
                        self.showOutputView = false
                        print("API response was not valid or was empty.")
                    }
                }
            }
        }
    }
        
        func loadImage() {
            DispatchQueue.main.async(){
                Task {
                    let result = await extractCodeFromImg(from: self.image)
                    if (result.lowercased() != "no source code detected" && result.lowercased() != "poor network" && result.lowercased() != "error") {
                        self.recognizedText = result
                        recognizeLanguage()
                    } else {
                        self.recognizedText = "Error or no source code detected."
                    }
                }
            }
        }
    
  
    }


