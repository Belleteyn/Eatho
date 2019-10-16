//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import PDFKit


class PdfCreator {
    
    private enum Alignment {
        case Left, Center
    }
    
    private let pageWidth = 8.5 * 72.0
    private let pageHeight = 11 * 72.0
    private let pageRect: CGRect!

    init() {
        pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
    }
    
    func createPdf(title: String, userName: String) -> Data? {
        let metadata: [String: Any] = [
            kCGPDFContextCreator as String: "Eatho app",
            title: title
        ]

        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = metadata

        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        let data = renderer.pdfData { (context) in
            context.beginPage()
            
            let userNameRect = addRigthtAlignedLabel(text: userName, font: UIFont.systemFont(ofSize: 12.0), color: UIColor.darkGray, xOffset: 12, y: 20)
            let titleRect = addCenteredLabel(text: title, font: UIFont.systemFont(ofSize: 20), color: UIColor.darkGray, y: 36)
            
        }

        return data
    }
    
    private func addCenteredLabel(text: String, font: UIFont, color: UIColor, y: CGFloat) -> CGRect {
        let attributedString = attributedLabel(text: text, font: font, color: color)
        
        let labelSize = attributedString.size()
        let labelRect = CGRect(x: (pageRect.width - labelSize.width) / 2, y: y, width: labelSize.width, height: labelSize.height)
        
        attributedString.draw(in: labelRect)
        return labelRect
    }
    
    private func addRigthtAlignedLabel(text: String, font: UIFont, color: UIColor, xOffset: CGFloat, y: CGFloat) -> CGRect {
        let attributedString = attributedLabel(text: text, font: font, color: color)
        
        let labelSize = attributedString.size()
        let labelRect = CGRect(x: pageRect.width - labelSize.width - xOffset, y: y, width: labelSize.width, height: labelSize.height)
        
        attributedString.draw(in: labelRect)
        return labelRect
    }
    
    private func addLabel(text: String, font: UIFont, color: UIColor, x: CGFloat, y: CGFloat) -> CGRect {
        let attributedString = attributedLabel(text: text, font: font, color: color)
        
        let labelSize = attributedString.size()
        let labelRect = CGRect(x: x, y: y, width: labelSize.width, height: labelSize.height)
        
        attributedString.draw(in: labelRect)
        return labelRect
    }
    
    func attributedLabel(text: String, font: UIFont, color: UIColor) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    private func addTitle(title: String, pageRect: CGRect) -> CGFloat {
        let titleFont = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        let titleAttributes: [NSAttributedString.Key: Any] =
        [NSAttributedString.Key.font: titleFont]

        let attributedTitle = NSAttributedString(
        string: title,
        attributes: titleAttributes
        )

        let titleStringSize = attributedTitle.size()
        let titleStringRect = CGRect(
        x: (pageRect.width - titleStringSize.width) / 2.0,
        y: 36,
        width: titleStringSize.width,
        height: titleStringSize.height
        )

        attributedTitle.draw(in: titleStringRect)
        return titleStringRect.origin.y + titleStringRect.size.height
    }
}


class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = UIColor.darkGray
        
        let pdfView = PDFView()
        pdfView.frame = CGRect(x: 20, y: 20, width: 330, height: 600)
        
        let pdfCreator = PdfCreator()
        if let data = pdfCreator.createPdf(title: "Title!", userName: "username") {
          pdfView.document = PDFDocument(data: data)
          pdfView.autoScales = true
        }
        
        view.addSubview(pdfView)
        
        self.view = view
    }
    
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
