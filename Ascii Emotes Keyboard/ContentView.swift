//
//  ContentView.swift
//  Ascii Emotes Keyboard
//
//  Created by Kali Francia on 3/11/24.
//

import SwiftUI

struct ContentView: View {
    
    let appStoreLink = "https://apps.apple.com/us/app/ascii-emotes/id6479488898"
    
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
                        Text(LocalizedStringKey("Ascii Emotes"))
                            .font(.largeTitle)
                        Text(LocalizedStringKey("by Gino Francia"))
                            .font(.headline)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                }
                // How to Setup Section
                Section {
                    VStack (alignment: .leading) {
                        Text(LocalizedStringKey("Setup Instructions:"))
                            .font(.headline)
                        HStack {
                            Image(systemName: "hand.tap")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 19)
                                .foregroundStyle(Color.blue)
                            Text(LocalizedStringKey("Open Ascii Emotes in Settings"))
                        }
                        HStack {
                            Image(systemName: "keyboard")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 19)
                                .foregroundStyle(Color.text)
                            Text(LocalizedStringKey("Tap 'Keyboards'."))
                        }
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 19)
                                .foregroundStyle(Color.blue)
                            Text(LocalizedStringKey("Turn on 'Ascii Emotes'."))
                        }
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 19)
                                .foregroundStyle(Color.blue)
                            Text(LocalizedStringKey("Turn on 'Allow Full Access'."))
                        }
                        HStack {
                            Image(systemName: "heart.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 19)
                                .foregroundStyle(Color.red)
                            Text(LocalizedStringKey("Enjoy! ｡>‿‿◕｡"))
                        }
                        HStack {
                            Spacer()
                            Button(action: {
                                guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                                UIApplication.shared.open(settingsURL)
                            }) {
                                Image(systemName: "gearshape.fill")
                                Text(LocalizedStringKey("Open App Setings"))
                                Image(systemName: "chevron.right")
                            }
                            .buttonStyle(.bordered)
                            Spacer()
                        }
                    }
                } header: {
                    Text(LocalizedStringKey("How to Setup"))
                }
                // Section Buttons
                Section {
                    // About
                    NavigationLink(destination: AboutView()) {
                        Image(systemName: "info.circle.fill")
                            .foregroundStyle(Color.blue)
                        Text(LocalizedStringKey("About"))
                    }
                    // Follow Me
                    NavigationLink(destination: FollowMeView()) {
                        Image(systemName: "person.fill")
                            .foregroundStyle(Color.cyan)
                        Text(LocalizedStringKey("Follow Me"))
                    }
                    // Rate App
                    Button(action: {
                        if let url = URL(string: appStoreLink) {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundStyle(Color.yellow)
                            Text(LocalizedStringKey("Rate"))
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
                        let AV = UIActivityViewController(activityItems: [appStoreLink], applicationActivities: nil)
                        let activeScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
                        let rootViewController = (activeScene?.windows ?? []).first(where: { $0.isKeyWindow })?.rootViewController
                        // for iPad fix
                        if UIDevice.current.userInterfaceIdiom == .pad{
                            AV.popoverPresentationController?.sourceView = rootViewController?.view
                            AV.popoverPresentationController?.sourceRect = .zero
                        }
                        rootViewController?.present(AV, animated: true, completion: nil)
                        
                    }) {
                        HStack {
                            Image(systemName: "link")
                                .foregroundStyle(Color.gray)
                            Text(LocalizedStringKey("Share"))
                                .foregroundStyle(Color.text)
                            Spacer()
                            Image(systemName: "square.and.arrow.up")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 14)
                        }
                    }
                } header: {
                    Text(LocalizedStringKey("Ascii Emotes for iOS"))
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
