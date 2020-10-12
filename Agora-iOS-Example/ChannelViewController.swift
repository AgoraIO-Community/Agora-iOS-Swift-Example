//
//  ChannelViewController.swift
//  Agora-iOS-Example
//
//  Created by Max Cobb on 12/10/2020.
//  Copyright © 2020 Max Cobb. All rights reserved.
//

import UIKit
import AgoraRtcKit

class ChannelViewController: UIViewController {

    #error("change channelName and appId, then delete or comment this line")
    static let channelName = "changeme"
    static let appId = "changeme"

    /// Static token here, but can be dynamic if calling `joinChannelWithFetch` instead of `joinChannel`
    /// `joinChannelWithFetch` is found in AgoraToken.swift
    static var channelToken = ""

    #error("change tokenBaseURL, then delete or comment this line")
    static var tokenBaseURL = "http://localhost:8080"

    /// Setting to zero will tell Agora to assign one for you
    lazy var userID: UInt = 0

    var userRole: AgoraClientRole = .audience

    lazy var agkit: AgoraRtcEngineKit = {
        let engine = AgoraRtcEngineKit.sharedEngine(
            withAppId: ChannelViewController.appId,
            delegate: self
        )
        engine.setChannelProfile(.liveBroadcasting)
        engine.setClientRole(self.userRole)
        return engine
    }()

    var hostButton: UIButton?
    var closeButton: UIButton?

    var controlContainer: UIView?
    var camButton: UIButton?
    var micButton: UIButton?
    var flipButton: UIButton?
    var beautyButton: UIButton?

    var beautyOptions: AgoraBeautyOptions = {
        let bOpt = AgoraBeautyOptions()
        bOpt.smoothnessLevel = 1
        bOpt.rednessLevel = 0.1
        return bOpt
    }()

    var agoraVideoHolder = UIView()

    var remoteUserIDs: Set<UInt> = []
    var userVideoLookup: [UInt: AgoraRtcVideoCanvas] = [:] {
        didSet {
            reorganiseVideos()
        }
    }

    lazy var videoView: UIView = {
        let vview = UIView()
        vview.translatesAutoresizingMaskIntoConstraints = false
        return vview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.agoraVideoHolder)
        self.agoraVideoHolder.translatesAutoresizingMaskIntoConstraints = false
        self.addVideoViews()
        if ChannelViewController.channelToken.isEmpty {
            // Fetch token if our current one is empty
            self.joinChannelWithFetch()
        } else {
            self.joinChannel()
        }
    }

    func addVideoViews() {
        self.view.addSubview(self.videoView)
        self.addVideoButtons()
    }

    required init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
