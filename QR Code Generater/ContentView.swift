//
//  ContentView.swift
//  QR Code Generater
//
//  Created by R93 on 27/06/24.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    
    @State private var text = ""
    @State private var QRCodeImage: UIImage?
    @State private var historyURLs: [String] = []
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter the URL", text: $text)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.top , 16)
                    
                if text != "" {
                    Button("Generate QR Code") {
                        QRCodeImage = UIImage(data: generateQRCode(text: text)!)
                        if !historyURLs.contains(text) {
                            historyURLs.append(text)
                        }
                    }
                    .padding()
                    .font(.headline)
                    .foregroundColor(.primary)
                    .buttonStyle(.bordered)
                    .clipShape(Capsule())
                    .padding()
                }
                
                if QRCodeImage != nil {
                    QRCodeImagePreview(QRCodeImage: $QRCodeImage, text: $text)
                    
                    Button("Save QR Code to Gallery") {
                        if let renderImage = QRCodeImage {
                            UIImageWriteToSavedPhotosAlbum(renderImage, nil, nil, nil)
                        } else {
                            print("Failed to save image: Image is nil")
                        }
                    }
                }
                
                NavigationLink(destination: HistoryView(historyURLs: historyURLs)) {
                    Text("View History")
                        .font(.headline)
                        .padding()
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .padding()
                }
                Text("Created By Yash Khambhati ❤️")
                    .padding()
                    .foregroundColor(.gray)
                    .font(.headline)
                    .padding()
            }
            .padding()
            .padding(.top, 0)
            .navigationBarTitle("QR Code Generator", displayMode: .inline)
        }
        .ignoresSafeArea()
    }
    
    func generateQRCode(text: String) -> Data? {
        let filter = CIFilter.qrCodeGenerator()
        
        guard let data = text.data(using: .ascii, allowLossyConversion: false) else { return nil }
        filter.message = data
        guard let ciImage = filter.outputImage else { return nil }
        
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledImage = ciImage.transformed(by: transform)
        let uiImage = UIImage(ciImage: scaledImage)
        
        return uiImage.pngData()
    }
}

struct QRCodeImagePreview: View {
    
    @Binding var QRCodeImage: UIImage?
    @Binding var text: String
    
    var body: some View {
        VStack {
            Image(uiImage: QRCodeImage!)
                .resizable()
                .frame(width: 200, height: 200)
                .cornerRadius(5)
                .padding()
        }
    }
}

struct HistoryView: View {
    
    var historyURLs: [String]
    
    var body: some View {
        List(historyURLs, id: \.self) { url in
            Text(url)
        }
        .navigationTitle("History")
    }
}

#Preview {
    ContentView()
}

