//
//  TextParsingPDFs.swift
//  StudyBuddy
//
//  Created by Krish Kapoor on 13/02/2025.
//

import UIKit
import Vision
import PDFKit

// Extracts text content from a PDF file
// pdfURL: The URL of the PDF file to process
// completion: receives the extracted text as a String
func extractTextFromPDF(pdfURL: URL, completion: @escaping (String) -> Void) {
    guard let pdfDocument = PDFDocument(url: pdfURL) else {
        completion("")
        return
    }

    var extractedText = ""
    // handles text recognition for multiple pages
    let dispatchGroup = DispatchGroup()

    // Iterates through each page of the PDF
    for pageIndex in 0..<pdfDocument.pageCount {
        guard let page = pdfDocument.page(at: pageIndex) else { continue }
        // Convert PDFs page to image for OCR processing
        let pageRect = page.bounds(for: .mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        let image = renderer.image { ctx in
            // convert background to white and change coordinates
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

    // Completes when all pages have been processed
    dispatchGroup.notify(queue: .main) {
        completion(extractedText)
    }
}

// Performs OCR on a single image using Vision framework
func recognizeTextInImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
    // Convert UIImage to CGImage for Vision framework
    guard let cgImage = image.cgImage else {
        completion(nil)
        return
    }

    // Creates text recognition request
    let request = VNRecognizeTextRequest { request, error in
        guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
            completion(nil)
            return
        }

        // Extracts recognized text and join them
        let recognizedStrings = observations.compactMap { $0.topCandidates(1).first?.string }
        completion(recognizedStrings.joined(separator: "\n"))
    }

    // Set recognition level to accurate
    request.recognitionLevel = .accurate
    let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])

    // Perform text recognition
    DispatchQueue.global(qos: .userInitiated).async {
        do {
            try requestHandler.perform([request])
        } catch {
            completion(nil)
        }
    }
}
