import SwiftUI
import Charts

struct CodeScoreVisualizer: View {
    var efficiencyScore: Double
    var syntacticalAccuracyScore: Double
    var cleanlinessScore: Double
    
    var data: [(type: String, amount: Double)] {
        [
            (type: "Efficiency", amount: efficiencyScore),
            (type: "Syntactical Accuracy", amount: syntacticalAccuracyScore),
            (type: "Clean Code", amount: cleanlinessScore)
        ]
    }
    
    var maxCategory: String? {
        data.max { $0.amount < $1.amount }?.type
    }
    
    var body: some View {
        
        VStack{
            Text("Code Score")
                           .font(.largeTitle)
                           .fontWeight(.bold)
                           .foregroundColor(.black)
                           .padding()
            Chart(data, id: \.type) { dataItem in
                SectorMark(angle: .value("Metric", dataItem.amount),
                           innerRadius: .ratio(0.618),
                           angularInset: 1.5)
                .cornerRadius(15)
                .opacity(dataItem.type == maxCategory ? 1 : 0.5)
                .foregroundStyle(by: .value("Category", dataItem.type))
                .annotation(position:.overlay, alignment: .center) {
                    Text("\(Int(dataItem.amount))%")
                        .font(.caption)
                        .foregroundColor(.white)
                        .bold()
                }
                
            }
            .aspectRatio(contentMode: .fit)
            .chartLegend(position: .bottom, spacing: 20)
            .frame(height: 300)
            .padding(20)
        }
        
    }
}

// Dummy data for demonstration
