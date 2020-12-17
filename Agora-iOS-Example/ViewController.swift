//
//  ViewController.swift
//  Agora-iOS-Example
//
//  Created by Max Cobb on 12/10/2020.
//

import UIKit
import AgoraRtcKit

class ViewController: UIViewController {

    var joinButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        addJoinButton()
    }

    @objc func showChannelView() {
        self.present(ChannelViewController(), animated: true)
    }

    /// Adds a button which says "Join" to the view
    /// This button takes you to the `ChannelViewController`
    func addJoinButton() {
        if self.joinButton != nil {
            return
        }
        let button = UIButton(type: .custom)
        button.setTitle("Join", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.setTitleColor(.secondaryLabel, for: .focused)
        button.backgroundColor = .systemGray
        button.addTarget(self, action: #selector(showChannelView), for: .touchUpInside)
        self.view.addSubview(button)
        button.frame = CGRect(
            origin: CGPoint(x: self.view.bounds.width / 2 - 75, y: self.view.bounds.height / 2 - 25),
            size: CGSize(width: 150, height: 50)
        )
        button.autoresizingMask = [
            .flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin
        ]

        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 25
        self.joinButton = button
    }
}
