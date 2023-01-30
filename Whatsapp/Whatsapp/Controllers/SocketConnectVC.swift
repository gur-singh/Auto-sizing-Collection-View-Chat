//
//  SocketConnectVC.swift
//  Whatsapp
//
//  Created by PrabSharan on 26/01/23.
//

import UIKit
import IQKeyboardManagerSwift
class SocketConnectVC: UIViewController {

    @IBOutlet weak var bottomConstTextInput: NSLayoutConstraint!
    @IBOutlet weak var nameLabel: UILabel!
    private var modal: MessageViewModal!
    var user: User?

    @IBOutlet weak var heightMsgView: NSLayoutConstraint!
    @IBOutlet weak var textView: IQTextView!
    @IBOutlet weak var collectionView: UICollectionView!


    override func viewDidLoad() {
        super.viewDidLoad()
        initilalise()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        modal.emitEvent(.UserOffline)
    }
    func initilalise() {
        initialiseCollectionView()
        initModalWithName()
        initialiseTextView()
        initialiseTocloseKeyboard()
    }

    func initialiseTocloseKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func backActoin(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func initialiseTextView() {
        textView.delegate = self
    }
    func initialiseCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register( LeftChatBubbleCell.nib, forCellWithReuseIdentifier: LeftChatBubbleCell.identifier)
        collectionView.register( RightChatBubbleCell.nib, forCellWithReuseIdentifier: RightChatBubbleCell.identifier)
        let collectionFlowLayout = UICollectionViewFlowLayout()
        collectionFlowLayout.estimatedItemSize = CGSize(width: collectionView.frame.width, height: 30)
        collectionFlowLayout.minimumLineSpacing = 0
        collectionFlowLayout.minimumInteritemSpacing = 0
        collectionFlowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
        collectionFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        collectionView.collectionViewLayout = collectionFlowLayout

    }

    func initModalWithName() {
        modal = MessageViewModal(user!, self)
    }

    @IBAction func sendMsgAction(_ sender: Any) {
        modal.sendMessage(.Text, data: textView.text ?? "")
        heightDidChange(Constants.MinHeightTextV)
        textView.text = ""
    }
    
}
extension SocketConnectVC:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  modal?.messages?.count ?? 0
    }

    func isLastSectionVisible() -> Bool {

        guard !(modal.messages?.isEmpty ?? true) else { return true }

        let lastIndexPath = IndexPath(item: modal.messages?.count ?? 0 - 1, section: 0)

        return collectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }

    func scrollToBottom() {
        if !self.isLastSectionVisible() {
            self.scrollToLastItem(animated: true)
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let modal = modal.messages?[indexPath.row]
        let media =  Media(rawValue: modal?.media ?? 0) ?? .Text
        switch media {
        case .Text:
            return textForCellAtIndexPath(indexPath,modal)
        case.Image:return textForCellAtIndexPath(indexPath,modal)
        case .Video:return textForCellAtIndexPath(indexPath,modal)
        }
    }

    private  func textForCellAtIndexPath(_ indexPath:IndexPath,_ msg:Message?) -> UICollectionViewCell{
        let isRightCell =  msg?.user?.id ?? 0 == user?.id
        if isRightCell {
            guard  let rightCell = collectionView.dequeueReusableCell(withReuseIdentifier: RightChatBubbleCell.identifier, for: indexPath) as? RightChatBubbleCell else { return UICollectionViewCell() }

            rightCell.messageTitle.text = msg?.message
            rightCell.timeLabel.text = msg?.time

            return rightCell

        } else {
            guard  let leftCell = collectionView.dequeueReusableCell(withReuseIdentifier: LeftChatBubbleCell.identifier, for: indexPath) as? LeftChatBubbleCell else { return UICollectionViewCell() }

            leftCell.messageTitle.text = msg?.message
            leftCell.timeLabel.text = msg?.time

            return leftCell
        }
    }
   private func imageForCellAtIndexPath(_ indexPath:IndexPath,_ msg:Message?) -> UICollectionViewCell{
       UICollectionViewCell()
    }
    private  func videoForCellAtIndexPath(_ indexPath:IndexPath,_ msg:Message?) -> UICollectionViewCell{
       UICollectionViewCell()
    }
    public func scrollToLastItem(at pos: UICollectionView.ScrollPosition = .top, animated: Bool = true) {
        guard collectionView.numberOfSections > 0 else { return }

        let lastSection = collectionView.numberOfSections - 1
        let lastItemIndex = collectionView.numberOfItems(inSection: lastSection) - 1

        guard lastItemIndex >= 0 else { return }

        let indexPath = IndexPath(row: lastItemIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: pos, animated: animated)
    }

}
extension SocketConnectVC: EventsDelegate {
    func didReceiveEvent(_ events: Events) {
        switch events {
        case .Connected:
            print("Connected")
        case .ReceiveMessage(_):
            DispatchQueue.main.async {
                self.collectionView.reloadItems(at: [IndexPath(item: (self.modal.messages?.count ?? 0) - 1, section: 0)])
                self.scrollToBottom()
            }
            print("received")
        case .Disconnected:
            print("Disconnected")
        case .Typing:
            print("Typing")
        case .UserJoined(let string):
            print("UserJoined")
        case .UserOffline:
            print("UserOffline")
        case .Login:
            print("New user login")
        }
    }
}

extension SocketConnectVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        modal.emitEvent(.Typing)
        let height = textView.contentSize.height
        heightDidChange(height)
    }
    func heightDidChange(_ height:CGFloat) {
        self.view.layoutIfNeeded()
        if height >= Constants.MinHeightTextV && height != self.heightMsgView.constant && height < Constants.MaxHeightTextV {
            UIView.animate(withDuration: 1, delay: 0) {
                self.heightMsgView.constant = height
            }
        } else if height <= Constants.MinHeightTextV {
            self.heightMsgView.constant = Constants.MinHeightTextV
        }
    }
}
