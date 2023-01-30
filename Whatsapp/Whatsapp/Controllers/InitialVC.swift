//
//  InitialVC.swift
//  Whatsapp
//
//  Created by PrabSharan on 27/01/23.
//

import UIKit

class InitialVC: UIViewController {

    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    func moveToChat() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let VC = sb.instantiateViewController(withIdentifier: "SocketConnectVC") as! SocketConnectVC
        let user = User(textField.text ?? "", Int.random(in: 1...1000))
        VC.user = user
        self.navigationController?.pushViewController(VC, animated: true)
    }

    @IBAction func startChatAction(_ sender: Any) {
        moveToChat()
    }
}
