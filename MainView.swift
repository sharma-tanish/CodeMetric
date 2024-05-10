//  MainView.swift
//  GenerativeAICompiler

import SwiftUI

struct MainView: View {
    @State private var selectedTab = 1
    @State var content:String = ""

    var body: some View {
        TabView(selection: $selectedTab) {
            ContentView(recognizedText: $content)
                .tabItem {
                    Label("Editor", systemImage: "pencil")
                }
                .tag(1)

        

            ComplexityVisualizer(sourceCode:$content)
                .tabItem {
                    Label("Visualizer", systemImage: "chart.bar")
                }
                .tag(2)
        }
    }
}

struct VisualiserView:View{
    var body: some View{
        VStack{
            Text("Visualisation")
        }
    }
    
}
#Preview {
    MainView()
}
