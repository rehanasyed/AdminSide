
import UIKit
import Firebase
import FirebaseDatabase

class ChannelsViewController: UITableViewController {
  
    var UserType : String
    var ref : DatabaseReference!
  private let toolbarLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 15)
    return label
  }()
  
  private let channelCellIdentifier = "channelCell"
  private var currentChannelAlertController: UIAlertController?
  
  private let db = Firestore.firestore()
  
  private var channelReference: CollectionReference {
    return db.collection("conversations")
  }
  
  private var channels = [Channel]()
  private var channelListener: ListenerRegistration?
  
  private var currentUser: User
  
  deinit {
    channelListener?.remove()
  }
  
    init(currentUser: User,userType:String) {
    self.currentUser = currentUser
    self.UserType = userType
    super.init(style: .grouped)
    
    title = "Conversations"
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    
    ref = Database.database().reference()
    self.navigationItem.setHidesBackButton(true, animated: false)
    self.navigationController?.setToolbarHidden(true, animated: false)
    self.navigationController?.toolbar.isHidden = true
    
    channelListener = channelReference.addSnapshotListener { querySnapshot, error in
        guard let snapshot = querySnapshot else {
            print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
            return
        }
        
        if self.UserType == "User"{
            if let userChat  = snapshot.documentChanges.first(where: {($0.document.data() as! [String:String])["name"] == Auth.auth().currentUser!.phoneNumber}){
                self.handleDocumentChange(userChat)
            }
            else{
                self.createChannel(ChannelName: Auth.auth().currentUser!.phoneNumber!)
            }
            
        }
        
        else{
            snapshot.documentChanges.forEach { change in
                self.handleDocumentChange(change)
            }
            
        }
        
      }
    self.clearsSelectionOnViewWillAppear = true
    self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.channelCellIdentifier)
    self.tableView.bounces = false
   
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: false)
    navigationController?.isToolbarHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
     //navigationController?.setNavigationBarHidden(true, animated: false)
     // navigationController?.isToolbarHidden = true
  }
  
  // MARK: - Actions
  
  @objc private func signOut() {
    let ac = UIAlertController(title: nil, message: "Are you sure you want to sign out?", preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    ac.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { _ in
      do {
        try Auth.auth().signOut()
      } catch {
        print("Error signing out: \(error.localizedDescription)")
      }
    }))
    present(ac, animated: true, completion: nil)
  }
  
  @objc private func addButtonPressed() {
    let ac = UIAlertController(title: "Create a new Channel", message: nil, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    ac.addTextField { field in
      field.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
      field.enablesReturnKeyAutomatically = true
      field.autocapitalizationType = .words
      field.clearButtonMode = .whileEditing
      field.placeholder = "Channel name"
      field.returnKeyType = .done
      field.tintColor = .primary
    }
    
    let createAction = UIAlertAction(title: "Create", style: .default, handler: { _ in
      //self.createChannel()
    })
    createAction.isEnabled = false
    ac.addAction(createAction)
    ac.preferredAction = createAction
    
    present(ac, animated: true) {
      ac.textFields?.first?.becomeFirstResponder()
    }
    currentChannelAlertController = ac
  }
  
    @objc private func createUserChannel() {
        let ac = UIAlertController(title: "Enter UserName", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addTextField { field in
            field.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
            field.enablesReturnKeyAutomatically = true
            field.autocapitalizationType = .words
            field.clearButtonMode = .whileEditing
            field.placeholder = "User name"
            field.returnKeyType = .done
            field.tintColor = .primary
            
        }
        
        let createAction = UIAlertAction(title: "Submit", style: .default, handler: { _ in
            //self.createChannel()
        })
        createAction.isEnabled = false
        ac.addAction(createAction)
        ac.preferredAction = createAction
        
        present(ac, animated: true) {
            ac.textFields?.first?.becomeFirstResponder()
        }
        currentChannelAlertController = ac
    }
    
    
  @objc private func textFieldDidChange(_ field: UITextField) {
    guard let ac = currentChannelAlertController else {
      return
    }
    
    ac.preferredAction?.isEnabled = field.hasText
  }
  
  // MARK: - Helpers
  
    private func createChannel(ChannelName channelName : String, completionHandler : ((_ channel :Channel)->Void)? = nil) {

    let channel = Channel(name: channelName)
    //let documentID = channel.representation["id"] as? String ?? "TestID"
    
//    ref.child("Chats").updateChildValues([Auth.auth().currentUser!.uid:Auth.auth().currentUser!.email!])

    
    channelReference.addDocument(data: channel.representation) { error in
      if let e = error {
        
        print("Error saving channel: \(e.localizedDescription)")
      }
      else{
        //completionHandler!(channel)
        }
    }
  }
  
  private func addChannelToTable(_ channel: Channel) {
    guard !channels.contains(channel) else {
      return
    }
    
    channels.append(channel)
    channels.sort()
    
    guard let index = channels.index(of: channel) else {
      return
    }
    tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
  }
  
  private func updateChannelInTable(_ channel: Channel) {
    guard let index = channels.index(of: channel) else {
      return
    }
    
    channels[index] = channel
    tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
  }
  
  private func removeChannelFromTable(_ channel: Channel) {
    guard let index = channels.index(of: channel) else {
      return
    }
    
    channels.remove(at: index)
    tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
  }
  
  private func handleDocumentChange(_ change: DocumentChange) {
    guard let channel = Channel(document: change.document) else {
      return
    }
    
    if self.UserType == "User"{
        let chatVC = ChatScreenVC(user: Auth.auth().currentUser!, channel: channel)
        navigationController?.pushViewController(chatVC, animated: false)
    }
    
    else{
        switch change.type {
        case .added:
            addChannelToTable(channel)
            
        case .modified:
            updateChannelInTable(channel)
            
        case .removed:
            removeChannelFromTable(channel)
        }
    }
   
  }
    
    func saveChannelIdInDB(DocumentID id : String){
        
    }
  
}

// MARK: - TableViewDelegate

extension ChannelsViewController {
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return channels.count
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 55
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: channelCellIdentifier, for: indexPath)
    
    cell.accessoryType = .disclosureIndicator
    cell.textLabel?.text = channels[indexPath.row].name
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let channel = channels[indexPath.row]
    let vc = ChatScreenVC(user: currentUser, channel: channel)
    navigationController?.pushViewController(vc, animated: true)
  }
  
}
