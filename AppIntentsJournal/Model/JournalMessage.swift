/*
See LICENSE folder for this sample’s licensing information.

Abstract: The model object representing a journal entry's message, which is rich text stored as Data.

*/

import SwiftData
import UIKit

@Model
final class JournalMessage {
    var messageData: Data

    convenience init(_ string: AttributedString) throws {
        var formattedString = string
        formattedString.font = .systemFont(ofSize: UIFont.labelFontSize)
        formattedString.foregroundColor = .label
        let string = NSAttributedString(formattedString)
        try self.init(string)
    }
    
    init(_ string: NSAttributedString) throws {
        messageData = try string.data(
            from: NSRange(location: 0, length: string.length),
            documentAttributes: [.documentType: NSAttributedString.DocumentType.rtfd]
        )
    }
    
    var asNSAttributedString: NSAttributedString {
        do {
            return try NSAttributedString(data: messageData, documentAttributes: nil)
        } catch {
            return NSAttributedString(string: "")
        }
    }

    var asAttributedString: AttributedString {
        return AttributedString(asNSAttributedString)
    }
}
