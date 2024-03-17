//
//  AboutView.swift
//  Ascii Emotes Keyboard
//
//  Created by Kali Francia on 3/17/24.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        NavigationStack {
            List {
                // About the Keyboard Section
                Section {
                    VStack (alignment: .leading, spacing: 10) {
                        Text("The Ascii Emotes keyboard app is the result of a passion project to reintroduce the joy of using fun ASCII emotes in everyday messaging!")
                        Text("The keyboard is designed to provide an easy-to-use experience and features a modern design language tailored for iOS devices.")
                        Text("｡>‿‿◕｡")
                    }
                    .padding(.bottom, 3)
                } header: {
                    Text("About Ascii Emotes")
                }
                // Features
                Section {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "keyboard")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 19)
                                .foregroundStyle(Color.text)
                            Text("Easy access to a variety of ASCII emotes!")
                        }
                        HStack {
                            Image(systemName: "paintbrush.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 19)
                                .foregroundStyle(Color.text)
                            Text("Modern design language tailored for iOS devices!")
                        }
                        HStack {
                            Image(systemName: "moon.stars.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 19)
                                .foregroundStyle(Color.yellow)
                            Text("Auto dark and light mode switching!")
                        }
                        HStack {
                            Image(systemName: "globe")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 19)
                                .foregroundStyle(Color.blue)
                            Text("Support for multiple language localizations!")
                        }
                        HStack {
                            Image(systemName: "iphone.radiowaves.left.and.right")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 19)
                                .foregroundStyle(Color.text)
                            Text("Haptic feedback on all buttons!")
                        }
                    }
                } header: {
                    Text("Features")
                }
                // GitHub Section
                Section {
                    VStack (alignment: .leading, spacing: 10) {
                        Text("You can access the complete source code of the app on GitHub!")
                        HStack {
                            Spacer()
                            Button(action: {
                                if let url = URL(string: "https://github.com/ActualFrancia/Ascii-Emotes-Keyboard") {
                                    UIApplication.shared.open(url)
                                }
                            }) {
                                Image(systemName: "link")
                                Text("GitHub Repository")
                                Image(systemName: "chevron.right")
                                
                            }
                            Spacer()
                        }
                        .buttonStyle(.bordered)
                    }
                } header: {
                    Text("Source Code")
                } footer: {
                    Text("Feel free to leave feedback to help development!")
                }
            }
        }
        .navigationTitle("About")
    }
}

#Preview {
    AboutView()
}
