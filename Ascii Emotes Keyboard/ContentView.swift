//
//  ContentView.swift
//  Ascii Emotes Keyboard
//
//  Created by Kali Francia on 3/11/24.
//

import SwiftUI

struct ContentView: View {
    
    // TODO: Once on the app store, add links to app in Rate and Share App
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack (alignment: .center) {
                        Image("InternalAppIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        Text("Ascii Emotes")
                            .font(.largeTitle)
                        Text("by Gino Francia")
                            .font(.headline)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                }
                // How to Setup Section
                Section {
                    VStack (alignment: .leading) {
                        Text("Setup Instructions:")
                            .font(.headline)
                        HStack {
                            Image(systemName: "hand.tap")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 19)
                                .foregroundStyle(Color.blue)
                            Text("Open Ascii Emotes in Settings")
                        }
                        HStack {
                            Image(systemName: "keyboard")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 19)
                                .foregroundStyle(Color.text)
                            Text("Tap 'Keyboards'.")
                        }
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 19)
                                .foregroundStyle(Color.blue)
                            Text("Turn on 'Ascii Emotes'.")
                        }
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 19)
                                .foregroundStyle(Color.blue)
                            Text("Turn on 'Allow Full Access'.")
                        }
                        HStack {
                            Image(systemName: "heart.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 19)
                                .foregroundStyle(Color.red)
                            Text("Enjoy! ｡>‿‿◕｡")
                        }
                        HStack {
                            Spacer()
                            Button(action: {
                                guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                                UIApplication.shared.open(settingsURL)
                            }) {
                                Image(systemName: "gearshape.fill")
                                Text("Open App Setings")
                                Image(systemName: "chevron.right")
                            }
                            .buttonStyle(.bordered)
                            Spacer()
                        }
                    }
                } header: {
                    Text("How to Setup")
                }
                // Section Buttons
                Section {
                    // About
                    NavigationLink(destination: AboutView()) {
                        Image(systemName: "info.circle.fill")
                            .foregroundStyle(Color.blue)
                        Text("About")
                    }
                    // Follow Me
                    NavigationLink(destination: FollowMeView()) {
                        Image(systemName: "person.fill")
                            .foregroundStyle(Color.cyan)
                        Text("Follow Me")
                    }
                    // Rate App
                    Button(action: {
                        print("App Rate Pressed")
                    }) {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundStyle(Color.yellow)
                            Text("Rate")
                                .foregroundStyle(Color.text)
                            Spacer()
                            Image(systemName: "square.and.arrow.up")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 14)
                        }
                    }
                    // Share App
                    Button(action: {
                        print("Share Pressed")
                    }) {
                        HStack {
                            Image(systemName: "link")
                                .foregroundStyle(Color.gray)
                            Text("Share")
                                .foregroundStyle(Color.text)
                            Spacer()
                            Image(systemName: "square.and.arrow.up")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 14)
                        }
                    }
                } header: {
                    Text("Ascii Emotes for iOS")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
