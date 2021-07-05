//
//  AgoraToken.swift
//  Agora-iOS-Example
//
//  Created by Max Cobb on 12/10/2020.
//  Copyright © 2020 Max Cobb. All rights reserved.
//

import UIKit

extension ChannelViewController {
    /// Join the Agora channel by first fetching the token.
    @objc func joinChannelWithFetch() {
        guard let tokenURL = ChannelViewController.tokenBaseURL else {
            return
        }
        self.agkit.enableVideo()
        AgoraToken.fetchToken(
            urlBase: tokenURL,
            channelName: ChannelViewController.channelName,
            userId: self.userID
        ) { result in
            switch result {
            case .success(let channelToken):
                ChannelViewController.channelToken = channelToken
                self.joinChannel()
            case .failure(let err):
                print(err)
                DispatchQueue.main.async {
                    let alertView = UIAlertController(
                        title: "Token Error",
                        message: "Could not access server for valid token. Please check your connection and try again.",
                        preferredStyle: .alert
                    )
                    alertView.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                        self.leaveChannel()
                    }))
                    self.present(alertView, animated: true)
                }
            }
        }
    }

}

class AgoraToken {

    /// Error types to expect from fetchToken on failing ot retrieve valid token.
    enum TokenError: Error {
        case noData
        case invalidData
        case invalidURL
    }

    /// Requests the token from our backend token service
    /// - Parameter urlBase: base URL specifying where the token server is located
    /// - Parameter channelName: Name of the channel we're requesting for
    /// - Parameter userId: User ID of the user trying to join (0 for any user)
    /// - Parameter callback: Callback method for returning either the string token or error
    static func fetchToken(
        urlBase: String, channelName: String, userId: UInt,
        callback: @escaping (Result<String, Error>) -> Void
    ) {
        guard let fullURL = URL(string: "\(urlBase)/rtc/\(channelName)/publisher/uid/\(userId)/") else {
            callback(.failure(TokenError.invalidURL))
            return
        }
        var request = URLRequest(
            url: fullURL,
            timeoutInterval: 10
        )
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, _, err in
            guard let data = data else {
                if let err = err {
                    callback(.failure(err))
                } else {
                    callback(.failure(TokenError.noData))
                }
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseDict = responseJSON as? [String: Any], let token = responseDict["rtcToken"] as? String {
                callback(.success(token))
            } else {
                callback(.failure(TokenError.invalidData))
            }
        }

        task.resume()
    }
}
