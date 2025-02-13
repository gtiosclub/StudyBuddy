import Vision
import PDFKit
import UIKit

class TextRecognizer {
    enum ExtractionError: Error {
        case pdfLoadFailed
        case pageProcessingFailed(Int, Error)
        case imageConversionFailed(Int)
    }
    
    func extractText(from url: URL, completion: @escaping (Result<[String], ExtractionError>) -> Void) {
        guard let pdfDocument = PDFDocument(url: url) else {
            completion(.failure(.pdfLoadFailed))
            return
        }
        
        var allText: [String] = []
        var extractionErrors: [Error] = []
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "com.pdfrecognizer.extraction", qos: .userInitiated, attributes: .concurrent)
        
        for pageIndex in 0..<pdfDocument.pageCount {
            group.enter()
            
            queue.async {
                guard let page = pdfDocument.page(at: pageIndex) else {
                    group.leave()
                    return
                }
                
                let pageRect = page.bounds(for: .mediaBox)
                UIGraphicsBeginImageContextWithOptions(pageRect.size, true, 0.0)
                guard let context = UIGraphicsGetCurrentContext() else {
                    extractionErrors.append(ExtractionError.imageConversionFailed(pageIndex))
                    group.leave()
                    return
                }
                
                // Fill white background
                context.setFillColor(UIColor.white.cgColor)
                context.fill(pageRect)
                
                // Render PDF page
                context.translateBy(x: 0.0, y: pageRect.size.height)
                context.scaleBy(x: 1.0, y: -1.0)
                page.draw(with: .mediaBox, to: context)
                
                guard let image = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
                    UIGraphicsEndImageContext()
                    extractionErrors.append(ExtractionError.imageConversionFailed(pageIndex))
                    group.leave()
                    return
                }
                
                UIGraphicsEndImageContext()
                
                let requestHandler = VNImageRequestHandler(cgImage: image)
                let request = VNRecognizeTextRequest { request, error in
                    defer { group.leave() }
                    
                    if let error = error {
                        extractionErrors.append(ExtractionError.pageProcessingFailed(pageIndex, error))
                        return
                    }
                    
                    guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
                    
                    let pageText = observations.compactMap { observation in
                        observation.topCandidates(3).first?.string
                    }
                    
                    DispatchQueue.main.async {
                        allText.append(contentsOf: pageText)
                    }
                }
                
                request.revision = 2
                request.recognitionLevel = .accurate
                request.usesLanguageCorrection = true
                
                do {
                    try requestHandler.perform([request])
                } catch {
                    extractionErrors.append(ExtractionError.pageProcessingFailed(pageIndex, error))
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            if extractionErrors.isEmpty {
                completion(.success(allText))
            } else {
                if let firstError = extractionErrors.first as? ExtractionError {
                    completion(.failure(firstError))
                }
            }
        }
    }
}

