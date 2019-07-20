//
//  ChatScreenVC.swift
//  ChatApp
//
//  Created by Hasan Tahir on 15/09/2018.
//  Copyright © 2018 Hasan Tahir. All rights reserved.
//

import UIKit
import Firebase
import MessageKit
import Messages
import MessageUI
import MessageInputBar
import FirebaseFirestore
import Photos
import FirebaseAuth
import FirebaseStorage

class ChatScreenVC: MessagesViewController {
    
    private let user: User
    private let channel: Channel
    
    private var messages: [Message] = []
    private var messageListener: ListenerRegistration?
    
    private let db = Firestore.firestore()
    private var reference: CollectionReference?
    
    private var isSendingPhoto = false {
        didSet {
            DispatchQueue.main.async {
                self.messageInputBar.leftStackViewItems.forEach { item in
                    //item.isEnabled = !self.isSendingPhoto
                }
            }
        }
    }
    
    private let storage = Storage.storage().reference()
    
    
    var cameraItem : InputBarButtonItem?

    deinit {
        messageListener?.remove()
    }

    
    init(user: User, channel: Channel) {
        self.user = user
        self.channel = channel
        super.init(nibName: nil, bundle: nil)
        
        title = channel.name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
      
        
        navigationItem.largeTitleDisplayMode = .never
        
        messagesCollectionView.contentInset  = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        maintainPositionOnKeyboardFrameChanged = true
        
       
        addBackButtonIfUser()

        guard let id = channel.id else {
            navigationController?.popViewController(animated: true)
            return
        }
        
        reference = db.collection(["channels", id, "thread"].joined(separator: "/"))
        addCameraBtn()
        retrieveData()
        //setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if AppConstant.currentAppMode == .User {
            self.navigationItem.setHidesBackButton(true, animated: false)
        }

        guard let id = channel.id else {
            navigationController?.popViewController(animated: true)
            return
        }
        
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        reference = db.collection(["channels", id, "thread"].joined(separator: "/"))
        self.tabBarController?.tabBar.isHidden = true
        
        messageInputBar.inputTextView.tintColor = UIColor.init(red: 1, green: 93, blue: 48, alpha: 1)
        messageInputBar.sendButton.setTitleColor(UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4 ), for: .normal)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    private func insertNewMessage(_ message: Message) {
        
        
        guard !messages.contains(message) else {
            return
        }
        messages.append(message)
        messages.sort()
    
        messagesCollectionView.reloadData()
        DispatchQueue.main.async {
        self.messagesCollectionView.scrollToBottom(animated: true)
        }
        let isLatestMessage = messages.index(of: message) == (messages.count - 1)
        let shouldScrollToBottom = messagesCollectionView.isAtBottom && isLatestMessage
        
        if shouldScrollToBottom {
            DispatchQueue.main.async {
                self.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }
    
 
    
    
}

extension ChatScreenVC: MessagesDataSource{
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func currentSender() -> Sender {
    return Sender(id: user.uid, displayName: "Test Sender")
    }
    
    // 2
    func numberOfMessages(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }
    
    // 3
    
    func messageForItem(at indexPath: IndexPath,
                         in messagesCollectionView: MessagesCollectionView) -> MessageType {
        
        return messages[indexPath.section]
        
    }
    func cellTopLabelAttributedText(for message: MessageType,
                                    at indexPath: IndexPath) -> NSAttributedString? {
        
        let name = message.sender.displayName
        return NSAttributedString(
            string: name,
            attributes: [
                .font: UIFont.preferredFont(forTextStyle: .caption1),
                .foregroundColor: UIColor(white: 0.3, alpha: 1)
            ]
        )
    }
    
    func addBackButtonIfUser(){
//        if AppConstant.currentAppMode == .Admin{
//            return
//        }
        
        let backButton = UIButton(frame: CGRect(x: 9, y: 50, width: 12, height: 21))
        backButton.setImage(UIImage(named: "Chevron"), for: .normal)
        backButton.addTarget(self, action: #selector(Back), for: .touchUpInside)
        //self.view.addSubview(backButton)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
    }
    
    @objc func Back(){
        //self.navigationController?.popToRootViewController(animated: true)
        //self.tabBarController?.dismiss(animated: false, completion: nil)
        if AppConstant.currentAppMode == .Admin{
            self.navigationController?.popViewController(animated: true)
        }
        else{
            self.tabBarController?.selectedIndex = 0
            guard let vcToPop = self.navigationController!.viewControllers.first(where: {$0 is ChatViewController}) else{return}
            
            self.navigationController?.popToViewController(vcToPop, animated: true)
            
        }
        
        
    }
    
}

extension ChatScreenVC: MessagesLayoutDelegate {
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath,
                    in messagesCollectionView: MessagesCollectionView) -> CGSize {
        
        // 1
        return .zero
    }
    
    func footerViewSize(for message: MessageType, at indexPath: IndexPath,
                        in messagesCollectionView: MessagesCollectionView) -> CGSize {
   
        return CGSize(width: 0, height: 8)
    }
    
    func heightForLocation(message: MessageType, at indexPath: IndexPath,
                           with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
    
        return 0
    }
    
    
   
}

extension ChatScreenVC: MessagesDisplayDelegate {
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath,
                         in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        return isFromCurrentSender(message: message) ? .primary : .incomingMessage
    }
    
    func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath,
                             in messagesCollectionView: MessagesCollectionView) -> Bool {
        
        return false
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath,
                      in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
      
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        
        return .bubbleTail(corner, .curved)
    }
}

extension ChatScreenVC : MessageInputBarDelegate{
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        
        let message = Message(user: user, content: text)
        
         save(message)
       
        inputBar.resignFirstResponder()
        
        inputBar.inputTextView.text = ""
    }
    private func save(_ message: Message) {
        reference?.addDocument(data: message.representation) { error in
            if let e = error {
                print("Error sending message: \(e.localizedDescription)")
                return
            }
            
            
            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToBottom()
        }
    }
    
    
    
}

extension ChatScreenVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func addCameraBtn(){
        
        cameraItem = InputBarButtonItem(type: .system)
        cameraItem!.tintColor = .primary
        cameraItem!.image = UIImage(named: "camera")
        
        // 2
        cameraItem!.addTarget(
            self,
            action: #selector(cameraButtonPressed),
            for: .primaryActionTriggered
        )
        cameraItem!.setSize(CGSize(width: 60, height: 30), animated: false)
        
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
        
        // 3
        messageInputBar.setStackViewItems([cameraItem!], forStack: .left, animated: false)
        
    }
    
    @objc private func cameraButtonPressed() {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {

            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let asset = info[.phAsset] as? PHAsset{
            let size = CGSize(width: 500, height: 500)
            PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: nil) { (selectedimage, info) in
                guard let image = selectedimage else{return}
                self.sendPhoto(image)
            }
        }
        
        else if let image = info[.originalImage] as? UIImage{
            self.sendPhoto(image)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }


}

//Helper
extension ChatScreenVC{
    
    private func sendPhoto(_ image: UIImage) {
        isSendingPhoto = true
        
        uploadImage(image, to: channel) { [weak self] url in
            
            guard let `self` = self else {
                return
            }
            self.isSendingPhoto = false
            
            guard let url = url else {
                return
            }
            
            var message = Message(user: self.user, image: image)
            message.downloadURL = url
            
            self.save(message)
            self.messagesCollectionView.scrollToBottom()
        }
    }
   
    private func uploadImage(_ image: UIImage, to channel: Channel, completion: @escaping (URL?) -> Void) {
        guard let channelID = channel.id else {
            completion(nil)
            return
        }
        
        
        guard let scaledImage = image.scaledToSafeUploadSize,
            let data = scaledImage.jpegData(compressionQuality: 0.4) else {
                completion(nil)
                return
        }
        
        let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
        let imageRef = storage.child(channelID).child(imageName)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        imageRef.putData(data, metadata: metadata) { (meta, error) in
            guard let _ = meta else {
                return
            }
        imageRef.downloadURL { (url, error) in
            completion(url)
        }
        
      
        }
        
    }
    
    private func handleDocumentChange(_ change: DocumentChange) {
        guard var message = Message(document: change.document)
            
        else {return}
        
        
        if let url = message.downloadURL {
            downloadImage(at: url) { [weak self] image in
                if self == nil {
                    return
                }
                guard let image = image else {
                    return
                }
                
                message.image = image
                message.kind = MessageKind.photo(MessageMediaItem(image: image))
                self?.insertNewMessage(message)
            }
        } else {
            insertNewMessage(message)
        }
    }
    
    private func downloadImage(at url: URL, completion: @escaping (UIImage?) -> Void) {
        let ref = Storage.storage().reference(forURL: url.absoluteString)
        let megaByte = Int64(1 * 1024 * 1024)
        
        ref.getData(maxSize: megaByte) { data, error in
            guard let imageData = data else {
                completion(nil)
                return
            }
            
            completion(UIImage(data: imageData))
        }
    }
    
    func retrieveData(){
        messageListener = reference?.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }
            snapshot.query.limit(to: 10)
            
            snapshot.documentChanges.forEach { change in
                self.handleDocumentChange(change)
            }
        }
    }
}

extension ChatScreenVC{
    
    private struct MessageMediaItem: MediaItem {
        
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


