//
//  ChannelViewController+Permissions.swift
//  Agora-iOS-Example
//
//  Created by Max Cobb on 12/10/2020.
//  Copyright © 2020 Max Cobb. All rights reserved.
//

// This file just contains some helper functions for requesting
// Camera + Microphone permissions.

import AVFoundation
import UIKit

extension ChannelViewController {

    func checkForPermissions() -> Bool {
        if self.userRole == .audience {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized: break
            case .notDetermined:
                ChannelViewController.requestCameraAccess { success in
                    if success {
                        self.toggleBroadcast()
                    } else {
                        ChannelViewController.errorVibe()
                    }
                }
                return false
            default:
                cameraMicSessingsPopup {
                    ChannelViewController.goToSettingsPage()
                }
                return false
            }
            switch AVCaptureDevice.authorizationStatus(for: .audio) {
            case .authorized: break
            case .notDetermined:
                ChannelViewController.requestMicrophoneAccess { success in
                    if success {
                        self.toggleBroadcast()
                    } else {
                        ChannelViewController.errorVibe()
                    }
                }
                return false
            default:
                cameraMicSessingsPopup { ChannelViewController.goToSettingsPage() }
                return false
            }
        }
        return true
    }

    static func requestCameraAccess(handler: ((Bool) -> Void)? = nil) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            handler?(granted)
        }
    }

    static func requestMicrophoneAccess(handler: ((Bool) -> Void)? = nil) {
        AVCaptureDevice.requestAccess(for: .audio) { granted in
            handler?(granted)
        }
    }

    static func goToSettingsPage() {
        UIApplication.shared.open(
            URL(string: UIApplication.openSettingsURLString)!,
            options: [:]
        ) { isTrue in
            print("something returned isTrue: \(isTrue)")
        }
    }

    static func errorVibe() {
        let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
        notificationFeedbackGenerator.prepare()
        notificationFeedbackGenerator.notificationOccurred(.error)
    }

    func cameraMicSessingsPopup(successHandler: @escaping () -> Void) {
        let alertView = UIAlertController(
            title: "Camera and Microphone",
            message: "To become a host, you must enable the microphone and camera",
            preferredStyle: .alert
        )
        alertView.addAction(UIAlertAction(title: "Not Now", style: .cancel, handler: { _ in
            ChannelViewController.errorVibe()
        }))
        alertView.addAction(UIAlertAction(title: "Give Access", style: .default, handler: { _ in
            successHandler()
        }))
        DispatchQueue.main.async {
            self.present(alertView, animated: true)
        }
    }
}
