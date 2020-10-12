//
//  ChannelViewController+AgoraRtcEngineDelegate.swift
//  Agora-iOS-Example
//
//  Created by Max Cobb on 12/10/2020.
//  Copyright © 2020 Max Cobb. All rights reserved.
//

import AgoraRtcKit

extension ChannelViewController: AgoraRtcEngineDelegate {
    func rtcEngineVideoDidStop(_ engine: AgoraRtcEngineKit) {
        print("Agora Engine Video Stopped")
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid: UInt, size: CGSize, elapsed: Int) {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        let hostingView = UIView()
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(hostingView)
        videoCanvas.view = hostingView
        videoCanvas.renderMode = .hidden
        self.agkit.setupRemoteVideo(videoCanvas)
        userVideoLookup[uid] = videoCanvas
    }

    /// Called when the user role successfully changes
    /// - Parameters:
    ///   - engine: AgoraRtcEngine of this session.
    ///   - oldRole: Previous role of the user.
    ///   - newRole: New role of the user.
    func rtcEngine(
        _ engine: AgoraRtcEngineKit,
        didClientRoleChanged oldRole: AgoraClientRole,
        newRole: AgoraClientRole
    ) {
        let hostButton = self.getHostButton()
        hostButton.isEnabled = true
        let isHost = newRole == .broadcaster
        hostButton.backgroundColor = isHost ? .systemGreen : .systemRed
        hostButton.setTitle("Host" + (isHost ? "ing" : ""), for: .normal)
        if !isHost {
            userVideoLookup.removeValue(forKey: self.userID)
        }

        // Only show the camera options when we are a broadcaster
        self.getControlContainer().isHidden = !isHost
    }

    func rtcEngine(
        _ engine: AgoraRtcEngineKit,
        didJoinedOfUid uid: UInt,
        elapsed: Int
    ) {
        // Keeping track of all people in the session
        remoteUserIDs.insert(uid)
    }

    func rtcEngine(
        _ engine: AgoraRtcEngineKit,
        didOfflineOfUid uid: UInt,
        reason: AgoraUserOfflineReason
    ) {
        // Removing on quit and dropped only
        // the other option is `.becomeAudience`,
        // which means it's still relevant.
        if reason == .quit || reason == .dropped {
            remoteUserIDs.remove(uid)
        } else {
            // User is no longer hosting, need to change the lookups
            // and remove this view from the list
            userVideoLookup.removeValue(forKey: uid)
        }
    }
}
