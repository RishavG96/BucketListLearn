//
//  ContentView.swift
//  BucketListLearn
//
//  Created by Rishav Gupta on 24/06/23.
//

import SwiftUI

struct User: Identifiable, Comparable { // Data Model - we do not tell the model how to sort itself
    let id = UUID()
    let firstName: String
    let lastName: String
    
    static func <(lhs: User, rhs: User) -> Bool {
        lhs.lastName < rhs.lastName
    }
}

enum LoadingState {
    case loading, success, failed
}

struct LoadingView: View {
    var body: some View {
        Text("Loading...")
    }
}

struct SuccessView: View {
    var body: some View {
        Text("Success!")
    }
}

struct FailedView: View {
    var body: some View {
        Text("Failed.")
    }
}

struct ContentView: View {
    let users = [
        User(firstName: "Arnold", lastName: "Rimmer"),
        User(firstName: "Kristine", lastName: "Kochanski"),
        User(firstName: "David", lastName: "Lister")
    ].sorted() // now we can use sorted() by conforming struct to Comparable
//    .sorted {
//        $0.lastName < $1.lastName
//    }
    // here it represents the layout of the code not the data
    // Int can use .sorted() as it conforms to Conformable protocol
    
    
    
    // UserDefaults - small data
    // documentsDirectory - large Data. Read and write data from permanent storage - sync with iCloud
    // in iOS all apps are sandBox - which means they run on a particular container on a hard to guess name. We cant guess to get the exact directory where the app is running through guesswork. Rely on Apple API.
    
    
    var loadingState = LoadingState.loading
    
    var body: some View {
        VStack {
            List(users) { user in
                Text("\(user.firstName) \(user.lastName)")
            }
            
            Text("Hello World!")
                .onTapGesture {
                    let str = "Test Message"
                    let url = getDocumentsDirectory().appendingPathComponent("message.txt")
                    
                    do {
                        try str.write(to: url, atomically: true, encoding: .utf8)
                        
                        let input = try String(contentsOf: url)
                        print(input)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            switch loadingState {
            case .loading:
                LoadingView()
            case .success:
                SuccessView()
            case .failed:
                FailedView()
            }
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // Atomic writing - Write all at once - System writes out the whole file to a temp file name and then in one go - renames it
    // objc - utf16 encoding
    // stift native encoding - utf8
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
