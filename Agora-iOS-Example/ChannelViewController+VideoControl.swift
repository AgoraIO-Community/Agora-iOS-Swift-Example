//
//  ChannelViewController+VideoControl.swift
//  Agora-iOS-Example
//
//  Created by Max Cobb on 12/10/2020.
//  Copyright © 2020 Max Cobb. All rights reserved.
//

import AgoraRtcKit

extension ChannelViewController {

    /// Setup the canvas and rendering for the device's local video
    func setupLocalAgoraVideo() {
        self.agoraVideoHolder.addSubview(self.localVideoView)
        self.addVideoButtons()
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = self.userID
        videoCanvas.view = self.localVideoView
        videoCanvas.renderMode = .hidden
        self.agkit.setupLocalVideo(videoCanvas)
        userVideoLookup[self.userID] = videoCanvas
    }

    /// Toggle the camera between on and off
    @objc func toggleCam() {
        let camButton = self.getCameraButton()
        camButton.isSelected.toggle()
        camButton.backgroundColor = camButton.isSelected ? .systemRed : .systemGray
        self.agkit.enableLocalVideo(!camButton.isSelected)
    }

    /// Toggle the microphone between on and off
    @objc func toggleMic() {
        let micButton = self.getMicButton()
        micButton.isSelected.toggle()
        micButton.backgroundColor = micButton.isSelected ? .systemRed : .systemGray
        self.agkit.muteLocalAudioStream(micButton.isSelected)
    }

    /// Turn on/off the 'beautify' effect. Visual and voice change.
    @objc func toggleBeautify() {
        let beautifyButton = self.getBeautifyButton()
        beautifyButton.isSelected.toggle()
        beautifyButton.backgroundColor = beautifyButton.isSelected ? .systemGreen : .systemGray
        self.agkit.setLocalVoiceChanger(beautifyButton.isSelected ? .voiceBeautyClear : .voiceChangerOff)
        self.agkit.setBeautyEffectOptions(beautifyButton.isSelected, options: self.beautyOptions)
    }

    @objc func flipCamera() {
        self.agkit.switchCamera()
    }

    /// Toggle between being a host or a member of the audience.
    /// On changing to being a broadcaster, the app first checks
    /// that it has access to both the microphone and camera on the device.
    @objc func toggleBroadcast() {
        // Check if we have access to mic + camera
        // before changing the user role.
        if !self.checkForPermissions() {
            return
        }
        // Swap the userRole
        self.userRole = self.userRole == .audience ? .broadcaster : .audience

        // Disable the button, it is re-enabled once the change of role is successful
        // as dictated by the delegate method
        DispatchQueue.main.async {
            // Need to point to the main thread due to the permission popups
            self.getHostButton().isEnabled = false
            self.agkit.setClientRole(self.userRole)
        }
    }

    /// Join the pre-configured Agora channel
    @objc func joinChannel() {
        self.agkit.enableVideo()
        self.agkit.joinChannel(
            byToken: ChannelViewController.channelToken,
            channelId: ChannelViewController.channelName,
            info: nil, uid: self.userID
        ) { [weak self] _, uid, _ in
            self?.userID = uid
            self?.getHostButton().isHidden = false
            self?.getCloseButton().isHidden = false
        }
    }

    func updateToken(_ newToken: String) {
        ChannelViewController.channelToken = newToken
        self.agkit.renewToken(newToken)
    }

    /// Leave the Agora channel and return to the main screen
    @objc func leaveChannel() {
        self.agkit.setupLocalVideo(nil)
        self.agkit.leaveChannel(nil)
        if self.userRole == .broadcaster {
            agkit.stopPreview()
        }
        AgoraRtcEngineKit.destroy()
        self.dismiss(animated: true)
    }

    /// Shuffle around the videos if multiple people are hosting.
    func reorganiseVideos() {
        if userVideoLookup.isEmpty {
            return
        }
        let vidCounts = userVideoLookup.count

        // I'm always applying an NxN grid, so if there are 12
        // We take on a grid of 4x4 (16).
        let maxSqrt = ceil(sqrt(CGFloat(vidCounts)))
        let multDim = 1 / maxSqrt
        for (idx, (_, canvas)) in userVideoLookup.enumerated() {
            guard let canView = canvas.view else {
                continue
            }
            // A bit hacky, but the next two lines effectively
            // clear the constraints.
            canView.removeFromSuperview()
            self.agoraVideoHolder.addSubview(canView)
            canView.frame.size = CGSize(
                width: self.agoraVideoHolder.bounds.width * multDim,
                height: self.agoraVideoHolder.bounds.height * multDim
            )
            canView.frame.origin = .zero
            if idx % Int(maxSqrt) != 0 {
                // First video in the list, so just put it at the top left
                canView.frame.origin.x = CGFloat(idx % Int(maxSqrt)) * self.agoraVideoHolder.bounds.width / maxSqrt
            }
            let yMod = Int(CGFloat(idx) / maxSqrt) % Int(maxSqrt)
            if yMod != 0 {
                canView.frame.origin.y = CGFloat(yMod) * self.agoraVideoHolder.bounds.height / maxSqrt
            }
            canView.autoresizingMask = .all
        }
    }

}
