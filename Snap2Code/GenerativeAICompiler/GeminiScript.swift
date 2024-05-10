//
//  GeminiScript.swift
//  GenerativeAICompiler
//
//  Created by Abhiraj on 01/01/24.
//

import Foundation
import GoogleGenerativeAI
import SwiftUI

func findProgLangFromCode(code:String) async -> String{
    let apiKey = "AIzaSyD5wtGchOv6eYQBM5Jd0W2FMKDPbjj_etM"
    let model = GenerativeModel(name: "gemini-pro", apiKey: apiKey)
    let prompt = "Find the programming language from the source code: \(code)"
    
    do {
        let response = try await model.generateContent(prompt)
        return response.text ?? "no response"
    }
    catch{
        return "error"
    }
}
func analyzeSourceCode(code:String) async -> String{
    let apiKey = "AIzaSyD5wtGchOv6eYQBM5Jd0W2FMKDPbjj_etM"
    let config = GenerationConfig(
        temperature: 1.0,
        topP: 0.95,
        topK: 0,
        maxOutputTokens: 8192)
    let model = GenerativeModel(name: "gemini-pro", apiKey: apiKey,generationConfig: config)
    let prompt = "You are an AI Code Review Assistant which analyzes the source code and returns :1. Comprehensive Syntax Review , 2. Errors , 3. Recommendation and Best Practises, 4. No of Errors , 5.Only Time Complexity notation of the whole source code and no description , 6. Only Space Complexity Notation of the whole source code and no description for input:\(code)"
        
        do {
            let response = try await model.generateContent(prompt)
            return response.text ?? "No response generated"
        } catch {
            return "error"
        }
    }
    
func generateCodeScore(code:String) async -> String{
    let apiKey = "AIzaSyD5wtGchOv6eYQBM5Jd0W2FMKDPbjj_etM"
    let config = GenerationConfig(
        temperature: 1.0,
        topP: 0.95,
        topK:0,
        maxOutputTokens: 8192)
    let model = GenerativeModel(name: "gemini-pro", apiKey: apiKey,generationConfig: config)
    let prompt = "You are a Code Quality Supervisor, based on the source code:\(code) generate only three integers: efficiencyScore,syntacticalAccuracyScore,cleanlinessScore (out of 100 for each metric) and provide no description or textual response only integers."
        
        do {
            let response = try await model.generateContent(prompt)
            return response.text ?? "No response generated"
        } catch {
            return "error"
        }
    }
    
 





func extractCodeFromImg(from image:UIImage) async -> String{
    let apiKey = "AIzaSyD5wtGchOv6eYQBM5Jd0W2FMKDPbjj_etM"
    let imageModel = GenerativeModel(name: "gemini-pro-vision", apiKey: apiKey)
    let prompt = "Extract the programming language source code from image and return it if it exists in the specified image , if no code is detected return 'no Source Code' , if language is not detected return 'Unknown' "
        
        do {
            let response = try await imageModel.generateContent(prompt,image)
          if let text = response.text {
            return text
          } else {
            return "No source code Detected"
          }
        } catch {
            if error.localizedDescription.lowercased().contains("network") {
            return "Poor Network"
          } else {
            return "Error"
          }
        }
    }
    
 
   



