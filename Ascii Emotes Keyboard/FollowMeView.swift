//
//  FollowMeView.swift
//  Ascii Emotes Keyboard
//
//  Created by Kali Francia on 3/17/24.
//

import SwiftUI

struct FollowMeView: View {
    
    var twitterURL = "https://twitter.com/actualfrancia"
    var blueSkyURL = "https://bsky.app/profile/francia.bsky.social"
    var githubURL = "https://github.com/ActualFrancia"
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    // Twitter (X)
                    Button(action: {
                        if let url = URL(string: twitterURL) {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image("X")
                                .resizable()
                                .foregroundStyle(Color.yellow)
                                .scaledToFill()
                                .frame(width: 19, height: 19)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                            Text("@actualfrancia")
                                .foregroundStyle(Color.text)
                            Spacer()
                            Image(systemName: "square.and.arrow.up")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 14)
                        }
                    }
                    // Blue Sky Social
                    Button(action: {
                        if let url = URL(string: blueSkyURL) {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image("BlueSky")
                                .resizable()
                                .foregroundStyle(Color.yellow)
                                .scaledToFit()
                                .frame(width: 19)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                            Text("@francia.bsky.social")
                                .foregroundStyle(Color.text)
                            Spacer()
                            Image(systemName: "square.and.arrow.up")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 14)
                        }
                    }
                    // GitHub
                    Button(action: {
                        if let url = URL(string: githubURL) {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image("Github")
                                .resizable()
                                .foregroundStyle(Color.yellow)
                                .scaledToFit()
                                .frame(width: 19)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                            Text("ActualFrancia")
                                .foregroundStyle(Color.text)
                            Spacer()
                            Image(systemName: "square.and.arrow.up")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 14)
                        }
                    }
                } header: {
                    Text(LocalizedStringKey("Social Media"))
                } footer: {
                    Text(LocalizedStringKey("Feel free to reach out to me on any social media platform to suggest new emotes or provide feedback on the app!"))
                }
            }
        } .navigationTitle(LocalizedStringKey("Follow Me"))
    }
}

#Preview {
    FollowMeView()
}
