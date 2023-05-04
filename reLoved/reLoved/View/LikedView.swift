import SwiftUI



struct LikedView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var image = UIImage()
    @State private var showSheet = false
    @StateObject var likedViewModel = LikedViewModel()
    @State var showAddPostView: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    VStack {
                        Button(action: { likedViewModel.fetchLikesListOfCurrentUser() }, label: {})
                        
                        VStack(alignment: .leading, spacing: 10) {
                            if likedViewModel.posts.count > 0 {
                                ForEach(likedViewModel.posts) { post in
                                    CardContainerView(post: post)
                                }
                                .padding(.vertical, 20)
                            } else {
                                Text("No Item has been liked").foregroundColor(Color.gray).padding(.top, 20)
                            }
                        } .navigationTitle("Liked Posts")
                        
                    }
                    
                }
                .padding(20)
            }
        }
        .onAppear {
            likedViewModel.fetchLikesListOfCurrentUser()
        }
    }
}


struct likedView_Previews: PreviewProvider {
    static var previews: some View {
        LikedView()
    }
}
