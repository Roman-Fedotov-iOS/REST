//
//  ContentView.swift
//  REST
//
//  Created by Roman Fedotov on 24.07.2021.
//

import SwiftUI

struct ContentView: View {
    
    @State var posts: [Post] = []
    
    var body: some View {
        NavigationView {
            List(posts) { post in
                VStack {
                    Text(post.title)
                        .fontWeight(.black)
                    Text(post.body)
                }
            } .onAppear() {
                Api().getPost { (posts) in
                    self.posts = posts
                }
            } .navigationBarTitle(Text("Posts"), displayMode: .inline)
        }
    }
}

struct Post: Codable, Identifiable {
    var id: Int
    var title: String
    var body: String
}

class Api {
    func getPost(completion: @escaping ([Post]) -> ()) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts")
        else {return}
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            let posts = try! JSONDecoder().decode([Post].self, from: data!)
            DispatchQueue.main.async {
                completion(posts)
            }
        }
        .resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
