import SwiftUI

struct RandomizedTextColorizer: View {
    @Binding var text: String
    
    var body: some View {
        RandomizedTextView(text: $text)
    }
}

struct RandomizedTextView: UIViewRepresentable {
    @Binding var text: String
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = true
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.backgroundColor = .white
        textView.delegate = context.coordinator
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        applyPseudoRandomColors(to: uiView)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    private func applyPseudoRandomColors(to textView: UITextView) {
        guard let attributedText = textView.attributedText.mutableCopy() as? NSMutableAttributedString else {
            return
        }
        let words = text.components(separatedBy: .whitespacesAndNewlines)
        let fullRange = NSRange(location: 0, length: attributedText.length)
        attributedText.removeAttribute(.foregroundColor, range: fullRange)
        words.forEach { word in
            let range = (attributedText.string as NSString).range(of: word)
            let color = vsCodeColor(for: word)
            attributedText.addAttribute(.foregroundColor, value: color, range: range)
        }
        textView.attributedText = attributedText
    }
    
    private func vsCodeColor(for string: String) -> UIColor {
        let seed = string.hashValue
        let index = abs(seed) % vsCodeColors.count
        return vsCodeColors[index]
    }
    
    let vsCodeColors: [UIColor] = [
        UIColor(red: 86/255, green: 156/255, blue: 214/255, alpha: 1.0),    // Blue
        UIColor(red: 197/255, green: 200/255, blue: 198/255, alpha: 1.0),   // Gray
        UIColor(red: 152/255, green: 195/255, blue: 121/255, alpha: 1.0),   // Light Green
        UIColor(red: 86/255, green: 156/255, blue: 214/255, alpha: 1.0),    // Blue
        UIColor(red: 255/255, green: 109/255, blue: 119/255, alpha: 1.0),   // Red
        UIColor(red: 155/255, green: 94/255, blue: 214/255, alpha: 1.0),    // Purple
        UIColor(red: 224/255, green: 108/255, blue: 117/255, alpha: 1.0),   // Pink
        UIColor(red: 97/255, green: 175/255, blue: 239/255, alpha: 1.0)     // Light Blue
    ]
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: RandomizedTextView
        
        init(parent: RandomizedTextView) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
            parent.applyPseudoRandomColors(to: textView)
        }
    }
}

