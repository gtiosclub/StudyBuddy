//
//  LLMEvaluator.swift
//  StudyBuddy
//
//  Created by Jordan Singer on 10/4/24. 
// Obtained from https://github.com/Gusi1804/fullmoon-ios-xcode15/blob/main/fullmoon/Models/LLMEvaluator.swift
//

import Foundation
import MLX
import MLXLLM
import MLXLMCommon
import MLXRandom
import SwiftUI

enum LLMEvaluatorError: Error {
    case modelNotFound(String)
}

@Observable
@MainActor
class LLMEvaluator {
    var running = false
    var cancelled = false
    var output = ""
    var modelInfo = ""
    var stat = ""
    var progress = 0.0
    var thinkingTime: TimeInterval?
    var collapsed: Bool = false
    var isThinking: Bool = false

    var elapsedTime: TimeInterval? {
        if let startTime {
            return Date().timeIntervalSince(startTime)
        }

        return nil
    }

    private var startTime: Date?

    var modelConfiguration = ModelConfiguration.defaultModel

    func switchModel(_ model: ModelConfiguration) async {
        progress = 0.0 // reset progress
        loadState = .idle
        modelConfiguration = model
        _ = try? await load(modelName: model.name)
    }

    /// parameters controlling the output
    let generateParameters = GenerateParameters(temperature: 0.5)
    let maxTokens = 4096

    /// update the display every N tokens -- 4 looks like it updates continuously
    /// and is low overhead.  observed ~15% reduction in tokens/s when updating
    /// on every token
    let displayEveryNTokens = 4

    enum LoadState {
        case idle
        case loaded(ModelContainer)
    }

    var loadState = LoadState.idle

    /// load and return the model -- can be called multiple times, subsequent calls will
    /// just return the loaded model
    func load(modelName: String) async throws -> ModelContainer {
        guard let model = ModelConfiguration.getModelByName(modelName) else {
            throw LLMEvaluatorError.modelNotFound(modelName)
        }

        switch loadState {
        case .idle:
            // limit the buffer cache
            MLX.GPU.set(cacheLimit: 20 * 1024 * 1024)

            let modelContainer = try await LLMModelFactory.shared.loadContainer(configuration: model) {
                [modelConfiguration] progress in
                Task { @MainActor in
                    self.modelInfo =
                        "Downloading \(modelConfiguration.name): \(Int(progress.fractionCompleted * 100))%"
                    self.progress = progress.fractionCompleted
                }
            }
            modelInfo =
                "Loaded \(modelConfiguration.id).  Weights: \(MLX.GPU.activeMemory / 1024 / 1024)M"
            loadState = .loaded(modelContainer)
            return modelContainer

        case let .loaded(modelContainer):
            return modelContainer
        }
    }

    func stop() {
        isThinking = false
        cancelled = true
    }

    func generate(modelName: String, thread: Thread, systemPrompt: String) async -> String {
        guard !running else { return "" }

        running = true
        cancelled = false
        output = ""
        startTime = Date()

        do {
            let modelContainer = try await load(modelName: modelName)

            // augment the prompt as needed
            let promptHistory = modelContainer.configuration.getPromptHistory(
                thread: thread,
                systemPrompt: systemPrompt
            )

            if modelContainer.configuration.modelType == .reasoning {
                isThinking = true
            }

            // each time you generate you will get something new
            MLXRandom.seed(UInt64(Date.timeIntervalSinceReferenceDate * 1000))

            let result = try await modelContainer.perform { context in
                let input = try await context.processor.prepare(input: .init(messages: promptHistory))
                return try MLXLMCommon.generate(
                    input: input, parameters: generateParameters, context: context
                ) { tokens in

                    var cancelled = false
                    Task { @MainActor in
                        cancelled = self.cancelled
                    }

                    // update the output -- this will make the view show the text as it generates
                    if tokens.count % displayEveryNTokens == 0 {
                        let text = context.tokenizer.decode(tokens: tokens)
                        Task { @MainActor in
                            self.output = text
                        }
                    }

                    if tokens.count >= maxTokens || cancelled {
                        return .stop
                    } else {
                        return .more
                    }
                }
            }

            // update the text if needed, e.g. we haven't displayed because of displayEveryNTokens
            if result.output != output {
                output = result.output
            }
            stat = " Tokens/second: \(String(format: "%.3f", result.tokensPerSecond))"

        } catch {
            output = "Failed: \(error)"
        }

        running = false
        return output
    }
}

// class LLMEvaluator {
//    private let modelName1B = "Llama-3.2-1B.mlx"
//    private let modelName3B = "Llama-3.2-3B.mlx"
//    
//    private let model1BURL = URL(string: "https://huggingface.co/mlx-community/Llama-3.2-1B/resolve/main/model.mlx")!
//    private let model3BURL = URL(string: "https://huggingface.co/mlx-community/Llama-3.2-3B/resolve/main/model.mlx")!
//    
//    private let destinationPath: URL
//    private var model: (any LLMModel)?
//    
//    init() {
//        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        destinationPath = documentsDirectory.appendingPathComponent("models")
//        
//        Task {
//            await setupModels()
//        }
//    }
//    
//    private func modelExists(name: String) -> Bool {
//        let modelPath = destinationPath.appendingPathComponent(name)
//        return FileManager.default.fileExists(atPath: modelPath.path)
//    }
//    
//    private func downloadModel(from url: URL, to filename: String) async -> Bool {
//        let destination = destinationPath.appendingPathComponent(filename)
//
//        if modelExists(name: filename) {
//            print("\(filename) already exists.")
//            return true
//        }
//
//        do {
//            let (tempURL, _) = try await URLSession.shared.download(from: url)
//            
//            try FileManager.default.createDirectory(at: destinationPath, withIntermediateDirectories: true)
//            try FileManager.default.moveItem(at: tempURL, to: destination)
//            
//            print("Successfully downloaded \(filename)")
//            return true
//        } catch {
//            print("Error downloading \(filename): \(error.localizedDescription)")
//            return false
//        }
//    }
//    
//    private func loadModel(name: String) -> (any LLMModel)? {
//        let modelPath = destinationPath.appendingPathComponent(name).path
//        do {
//            let model = try LlamaModel(URL(fileURLWithPath: modelPath))
//            print("Successfully loaded model: \(name)")
//            return model
//        } catch {
//            print("Failed to load model: \(name), error: \(error.localizedDescription)")
//            return nil
//        }
//    }
//    
//    private func setupModels() async {
//        let downloaded1B = await downloadModel(from: model1BURL, to: modelName1B)
//        let downloaded3B = await downloadModel(from: model3BURL, to: modelName3B)
//        
//        if downloaded1B {
//            model = loadModel(name: modelName1B)
//        } else if downloaded3B {
//            model = loadModel(name: modelName3B)
//        } else {
//            print("No model available.")
//        }
//    }
//    
//    func generateCompletion(prompt: String) async -> String {
//        guard let llamaModel = model as? LlamaModel else {
//            return "Model is not loaded or incompatible."
//        }
//
//        do {
//            let result = try await llamaModel.generate(text: prompt)
//            return result
//        } catch {
//            return "Error generating completion: \(error.localizedDescription)"
//        }
//    }
// }
