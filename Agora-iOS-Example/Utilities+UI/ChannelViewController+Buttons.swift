//
//  ChannelViewController+Buttons.swift
//  Agora-iOS-Example
//
//  Created by Max Cobb on 12/10/2020.
//  Copyright © 2020 Max Cobb. All rights reserved.
//

import UIKit

// This file mostly contains programatically created UIButtons,
// The buttons call the following methods found in ChannelViewController+VideoControl.swift:
// leaveChannel, toggleCam, toggleMic, flipCamera, toggleBroadcast, toggleBeautify

extension ChannelViewController {
    /// Add all the relevant buttons.
    /// The buttons are set to add to their respective parent views
    /// Whenever called, so I'm discarding the result for most of them here.
    func addVideoButtons() {
        self.getControlContainer().isHidden = true
        _ = self.getCameraButton()
        _ = self.getMicButton()
        _ = self.getFlipButton()
        _ = self.getBeautifyButton()
    }

    func getControlContainer() -> UIView {
        if let controlContainer = self.controlContainer {
            return controlContainer
        }
        let container = UIView()
        self.view.addSubview(container)
        container.frame = CGRect(
            origin: CGPoint(x: 0, y: self.view.bounds.height - 100),
            size: CGSize(width: self.view.bounds.width, height: 100)
        )
        container.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
        self.controlContainer = container
        return container
    }

    func getCameraButton() -> UIButton {
        if let camButton = self.camButton {
            return camButton
        }
        let container = self.getControlContainer()
        let button = UIButton.newToggleButton(
            unselected: "video", selected: "video.slash"
        )
        button.addTarget(self, action: #selector(toggleCam), for: .touchUpInside)
        container.addSubview(button)

        button.translatesAutoresizingMaskIntoConstraints = false
        [
            button.rightAnchor.constraint(equalTo: container.centerXAnchor, constant: -10),
            button.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20),
            button.widthAnchor.constraint(equalToConstant: 60),
            button.heightAnchor.constraint(equalToConstant: 60)
        ].forEach { $0.isActive = true }

        button.layer.cornerRadius = 30
        button.backgroundColor = .systemGray
        self.camButton = button
        return button
    }

    func getMicButton() -> UIButton {
        if let micButton = self.micButton {
            return micButton
        }
        let container = self.getControlContainer()
        let button = UIButton.newToggleButton(
            unselected: "mic", selected: "mic.slash"
        )
        button.addTarget(self, action: #selector(toggleMic), for: .touchUpInside)
        container.addSubview(button)

        button.translatesAutoresizingMaskIntoConstraints = false
        [
            button.leftAnchor.constraint(equalTo: container.centerXAnchor, constant: 10),
            button.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20),
            button.widthAnchor.constraint(equalToConstant: 60),
            button.heightAnchor.constraint(equalToConstant: 60)
        ].forEach { $0.isActive = true }

        button.backgroundColor = .systemGray
        button.layer.cornerRadius = 30
        self.micButton = button
        return button
    }

    func getFlipButton() -> UIButton {
        if let flipButton = self.flipButton {
            return flipButton
        }
        let container = self.getControlContainer()
        let button = UIButton.newToggleButton(unselected: "camera.rotate")
        button.addTarget(self, action: #selector(flipCamera), for: .touchUpInside)
        container.addSubview(button)
        let camButton = self.getCameraButton()

        button.translatesAutoresizingMaskIntoConstraints = false
        [
            button.rightAnchor.constraint(equalTo: camButton.leftAnchor, constant: -20),
            button.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20),
            button.widthAnchor.constraint(equalToConstant: 60),
            button.heightAnchor.constraint(equalToConstant: 60)
        ].forEach { $0.isActive = true }

        button.backgroundColor = .systemGray
        button.layer.cornerRadius = 30
        self.flipButton = button
        return button
    }

    func getBeautifyButton() -> UIButton {
        if let beautyButton = self.beautyButton {
            return beautyButton
        }
        let container = self.getControlContainer()
        let button = UIButton.newToggleButton(unselected: "wand.and.stars.inverse")
        button.addTarget(self, action: #selector(toggleBeautify), for: .touchUpInside)
        container.addSubview(button)
        let micButton = self.getMicButton()

        button.translatesAutoresizingMaskIntoConstraints = false
        [
            button.leftAnchor.constraint(equalTo: micButton.rightAnchor, constant: 20),
            button.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20),
            button.widthAnchor.constraint(equalToConstant: 60),
            button.heightAnchor.constraint(equalToConstant: 60)
        ].forEach { $0.isActive = true }

        button.backgroundColor = .systemGray
        button.layer.cornerRadius = 30
        self.beautyButton = button
        return button
    }

    func getCloseButton() -> UIButton {
        if let closeButton = self.closeButton {
            return closeButton
        }
        guard let chevronSymbol = UIImage(systemName: "chevron.left") else {
            fatalError("Could not create chevron.left symbol")
        }
        let button = UIButton.systemButton(with: chevronSymbol, target: self, action: #selector(leaveChannel))
        self.view.addSubview(button)

        button.translatesAutoresizingMaskIntoConstraints = false
        [
            button.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20)
        ].forEach { $0.isActive = true}
        self.closeButton = button
        return button
    }

    func getHostButton() -> UIButton {
        if let hostButton = self.hostButton {
            return hostButton
        }
        let button = UIButton(type: .custom)
        button.setTitle("Host", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.setTitleColor(.secondaryLabel, for: .focused)
        button.addTarget(self, action: #selector(toggleBroadcast), for: .touchUpInside)
        self.view.addSubview(button)

        button.frame = CGRect(
            origin: CGPoint(x: self.view.bounds.midX - 75, y: 50),
            size: CGSize(width: 150, height: 50)
        )
        button.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]

        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 25
        self.hostButton = button
        return button
    }
}
