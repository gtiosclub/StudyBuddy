//
//  Text.swift
//  StudyBuddy
//  Parsing Text from PDFs
//  Created by Krish Kapoor on 13/02/2025.
//

import UIKit
import Vision
import PDFKit

func extractTextFromPDF(pdfURL: URL, completion: @escaping (String) -> Void) {
    guard let pdfDocument = PDFDocument(url: pdfURL) else {
        completion("")
        return
    }

    var extractedText = ""
    let dispatchGroup = DispatchGroup()

    for pageIndex in 0..<pdfDocument.pageCount {
        guard let page = pdfDocument.page(at: pageIndex) else { continue }
        
        // Convert PDF page to image
        let pageRect = page.bounds(for: .mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        let image = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(pageRect)
            ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
            page.draw(with: .mediaBox, to: ctx.cgContext)
        }

        dispatchGroup.enter()
        recognizeTextInImage(image) { text in
            if let text = text {
                extractedText += text + "\n"
            }
            dispatchGroup.leave()
        }
    }

    dispatchGroup.notify(queue: .main) {
        completion(extractedText)
    }
}

func recognizeTextInImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
    guard let cgImage = image.cgImage else {
        completion(nil)
        return
    }

    let request = VNRecognizeTextRequest { request, error in
        guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
            completion(nil)
            return
        }

        let recognizedStrings = observations.compactMap { $0.topCandidates(1).first?.string }
        completion(recognizedStrings.joined(separator: "\n"))
    }

    request.recognitionLevel = .accurate
    let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])

    DispatchQueue.global(qos: .userInitiated).async {
        do {
            try requestHandler.perform([request])
        } catch {
            completion(nil)
        }
    }
}


