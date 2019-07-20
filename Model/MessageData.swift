//
//  MessageData.swift
//  EmergencyAppLocator
//
//  Created by Apple on 09/03/2019.
//  Copyright © 2019 Hasan Tahir. All rights reserved.
//


import Foundation
import UIKit
import class CoreLocation.CLLocation

/// An enum representing the kind of message and its underlying data.
public enum MessageData {
    
    /// A standard text message.
    ///
    /// NOTE: The font used for this message will be the value of the
    /// `messageLabelFont` property in the `MessagesCollectionViewFlowLayout` object.
    ///
    /// Tip: Using `MessageData.attributedText(NSAttributedString)` doesn't require you
    /// to set this property and results in higher performance.
    case text(String)
    
    /// A message with attributed text.
    case attributedText(NSAttributedString)
    
    /// A photo message.
    case photo(UIImage)
    
    /// A video message.
    case video(file: URL, thumbnail: UIImage)
    
    /// A location message.
    case location(CLLocation)
    
    /// An emoji message.
    case emoji(String)
    
    // MARK: - Not supported yet
    
    //    case audio(Data)
    //
    //    case system(String)
    //
    //    case custom(Any)
    //
    //    case placeholder
    
}
