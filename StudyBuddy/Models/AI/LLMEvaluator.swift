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
    private var model: MLX.Module?
    
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
    
    private func loadModel(name: String) -> MLX.Module? {
        let modelPath = destinationPath.appendingPathComponent(name).path
        guard let model = try? MLX.load(modelPath) else {
            print("Failed to load model: \(name)")
            return nil
        }
        return model
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
    
    func generateCompletion(prompt: String) -> String {
        guard let model = model else {
            return "Model is not loaded."
        }
        
        let inputTensor = MLX.Tensor(prompt)
        let outputTensor = model.forward(inputTensor)
        return outputTensor.toString()
    }
}


