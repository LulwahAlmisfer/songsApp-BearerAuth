//
//  SongList.swift
//  YT-Vapor-iOS-App
//
//  Created by Mikaela Caron on 10/19/21.
//

import SwiftUI

struct SongList: View {
    
    @StateObject var viewModel = SongListViewModel()
    
    @State var modal: ModalType? = nil
    @EnvironmentObject var auth: Auth
    
    var body: some View {
        NavigationView {
           
            VStack {
                Button("log out") {
                    auth.logout()
                  //  viewModel.songs = []
                }
            
                List {
                    ForEach(viewModel.songs) {
                         song in
                        Button {
                            print("selected")
                        } label: {
                            Text(song.title)
                                .font(.title3)
                                .foregroundColor(Color(.label))
                        }
                    }
                }
                .navigationTitle(Text("🎵 Songs"))
                .toolbar {
                    Button {
                        modal = .add
                    } label: {
                        Label("Add Song", systemImage: "plus.circle")
                    }
            }
            }
        }  .task {
            do {
                try await viewModel.fetchSongs()
            } catch {
                print("❌ Error: \(error)")
            }
        }
       
        .sheet(item: $modal, onDismiss: {
            Task {
                do {
                    try await viewModel.fetchSongs()
                } catch {
                    print("❌ Error: \(error)")
                }
            }
        }) { modal in
            switch modal {
            case .add:
                AddUpdateSong(viewModel: AddUpdateSongViewModel())
            case .update(let song):
                AddUpdateSong(viewModel: AddUpdateSongViewModel(currentSong: song))
            }
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SongList()
    }
}
