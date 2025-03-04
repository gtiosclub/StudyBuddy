//
//  LLMEvaluator.swift
//  StudyBuddy
//
//  Created by Matthew Dong on 2/27/25.
//
import Foundation
import MLX
import MLXLLM
import MLXLMCommon
import MLXRandom

class LLMEvaluator {
    private let modelName1B = "Llama-3.2-1B.mlx"
    private let modelName3B = "Llama-3.2-3B.mlx"
    
    private let model1BURL = URL(string: "https://huggingface.co/mlx-community/Llama-3.2-1B/resolve/main/model.mlx")!
    private let model3BURL = URL(string: "https://huggingface.co/mlx-community/Llama-3.2-3B/resolve/main/model.mlx")!
    
    private let destinationPath: URL
    private var model: (any LLMModel)?
    
    init() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        destinationPath = documentsDirectory.appendingPathComponent("models")
        
        Task {
            await setupModels()
        }
    }
    
    private func modelExists(name: String) -> Bool {
        let modelPath = destinationPath.appendingPathComponent(name)
        return FileManager.default.fileExists(atPath: modelPath.path)
    }
    
    private func downloadModel(from url: URL, to filename: String) async -> Bool {
        let destination = destinationPath.appendingPathComponent(filename)

        if modelExists(name: filename) {
            print("\(filename) already exists.")
            return true
        }

        do {
            let (tempURL, _) = try await URLSession.shared.download(from: url)
            
            try FileManager.default.createDirectory(at: destinationPath, withIntermediateDirectories: true)
            try FileManager.default.moveItem(at: tempURL, to: destination)
            
            print("Successfully downloaded \(filename)")
            return true
        } catch {
            print("Error downloading \(filename): \(error.localizedDescription)")
            return false
        }
    }
    
    private func loadModel(name: String) -> (any LLMModel)? {
        let modelPath = destinationPath.appendingPathComponent(name).path
        do {
            let model = try LlamaModel(URL(fileURLWithPath: modelPath))
            print("Successfully loaded model: \(name)")
            return model
        } catch {
            print("Failed to load model: \(name), error: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func setupModels() async {
        let downloaded1B = await downloadModel(from: model1BURL, to: modelName1B)
        let downloaded3B = await downloadModel(from: model3BURL, to: modelName3B)
        
        if downloaded1B {
            model = loadModel(name: modelName1B)
        } else if downloaded3B {
            model = loadModel(name: modelName3B)
        } else {
            print("No model available.")
        }
    }
    
    func generateCompletion(prompt: String) async -> String {
        guard let llamaModel = model as? LlamaModel else {
            return "Model is not loaded or incompatible."
        }

        do {
            let result = try await llamaModel.generate(text: prompt)
            return result
        } catch {
            return "Error generating completion: \(error.localizedDescription)"
        }
    }
}





