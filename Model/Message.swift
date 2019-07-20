

import Firebase
import MessageKit
import FirebaseFirestore
import FirebaseAuth

struct Message: MessageType {
   
  var kind: MessageKind
  let id: String?
  let content: String
  let sentDate: Date
  let sender: Sender
  
  var data: MessageData {
    if let image = image {
      return .photo(image)
    } else {
      return .text(content)
    }
  }
  
  var messageId: String {
    return id ?? UUID().uuidString
  }
  
  var image: UIImage? = nil
  var downloadURL: URL? = nil
  
  init(user: User, content: String) {
    sender = Sender(id: user.uid, displayName: "Test User")
    self.content = content
    sentDate = Date()
    id = nil
    kind = .text("")
  }
  
  init(user: User, image: UIImage) {
    sender = Sender(id: user.uid, displayName: "Test User")
    self.image = image
    content = ""
    sentDate = Date()
    id = nil
    let mediaItem = ImageMediaItem(image: image)
    kind = .photo(mediaItem)
   // mediaItem.
    
    //kind = .photo(MediaItem(image))
  }
  
  init?(document: QueryDocumentSnapshot) {
    let data = document.data()
    
    guard let timeStamp = data["created"] as? Timestamp else {
      return nil
    }
    guard let senderID = data["senderID"] as? String else {
      return nil
    }
    guard let senderName = data["senderName"] as? String else {
      return nil
    }
    
    id = document.documentID
    
    self.sentDate = timeStamp.dateValue()
    sender = Sender(id: senderID, displayName: senderName)
    
    if let content = data["content"] as? String {
      self.content = content
      self.kind = .text(self.content)
      downloadURL = nil
    } else if let urlString = data["url"] as? String, let url = URL(string: urlString) {
      downloadURL = url
      self.kind = .text("")
      content = ""
    } else {
      return nil
    }
  }
  
}

extension Message: DatabaseRepresentation {
  
  var representation: [String : Any] {
    var rep: [String : Any] = [
      "created": sentDate,
      "senderID": sender.id,
      "senderName": sender.displayName
    ]
    
    if let url = downloadURL {
      rep["url"] = url.absoluteString
    } else {
      rep["content"] = content
    }
    
    return rep
  }
    
    private struct ImageMediaItem: MediaItem {
        
        var url: URL?
        var image: UIImage?
        var placeholderImage: UIImage
        var size: CGSize
        
        init(image: UIImage) {
            self.image = image
            self.size = CGSize(width: 240, height: 240)
            self.placeholderImage = UIImage()
        }
        
    }
  
}

extension Message: Comparable {
  
  static func == (lhs: Message, rhs: Message) -> Bool {
    return lhs.id == rhs.id
  }
  
  static func < (lhs: Message, rhs: Message) -> Bool {
    return lhs.sentDate < rhs.sentDate
  }
  
}


