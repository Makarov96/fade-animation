//
//  ContentView.swift
//  sticky-header
//
//  Created by Guerin Steven Colocho Chacon on 27/07/23.
//

import SwiftUI

struct ContentView: View {
    var post: Array<Post> = []
    var userPost: Array<UserPost> = []
    let coordinateSpace: String = ""
    @State var offsetY: CGFloat = .zero
    @State var opacity: Bool = false
    @State var scaleTransition: Bool = false
    @State var showImage:Bool = false
   
    init(){
        let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = UIColor.clear
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterialDark) // or dark
            
            let scrollingAppearance = UINavigationBarAppearance()
            scrollingAppearance.configureWithTransparentBackground()
        scrollingAppearance.backgroundColor = UIColor(named: "customGray") // your view (superview) color
            
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = scrollingAppearance
            UINavigationBar.appearance().compactAppearance = scrollingAppearance
        
        post = getPosts()
        userPost = getUsersPost()
        
    }
    var body: some View {
        NavigationView {
            ZStack(alignment:.bottom) {
                Color("customGray").ignoresSafeArea()
                    ScrollView
                    {
                      
                        VStack(spacing:10){
                           
                            UserInfo()
                            UserDetail()
                            Spacer()
                            UserActions()
                            Spacer()
                            
                            Divider().frame(width: 350, height: 1).overlay(.white.opacity(0.1))
                            
                            HStack{
                                Text("Post Categories")
                                    .foregroundColor(.white)
                                    .fontWeight(.medium)
                                    .frame( alignment:.leading)
                                Text("(\(post.count) Post)")
                                    .foregroundColor(.white)
                                    .fontWeight(.light)
                                    .font(.system(size: 15))
                                Spacer()
                            }
                           UserHistories(post: post)
                             ForEach(self.userPost){
                                    singlePost in
                                 UserCardPost(postDetail: singlePost)
                                
                             }
                             .rotation3DEffect(
                                 Angle(degrees: scaleTransition ? 0 : 50),
                                 axis: (x: 1, y: 0, z: 0),
                                 anchor: .center,
                                 anchorZ: 0.0,
                                 perspective: 3
                             )
                            .opacity(opacity ? 1.0 : 0.0)
                             .frame(width: scaleTransition ? 300:0.0)
                             
                          
                        }
                       .padding(.horizontal,10)
                       .background(GeometryReader {
                                       Color.clear.preference(key: ViewOffsetKey.self,
                                           value: -$0.frame(in: .named("scroll")).origin.y)
                                   })
                       .onPreferenceChange(ViewOffsetKey.self) {
                          let opacityValue = $0
                           
                           withAnimation(.easeIn) {
                               if opacityValue > 270{
                                   showImage = true
                               }else {
                                   showImage = false
                               }
                           }
                           
                           withAnimation(.easeIn(duration: 0.39)) {
                               if opacityValue > 90{
                                   scaleTransition = true
                               }else {
                                   scaleTransition = false
                               }
                           }
                           
                           withAnimation(Animation.spring().speed(0.8)) {
                              
                               if opacityValue > 100 {
                                   opacity = true
                               }else {
                                   opacity = false
                               }
                               
                            }
                           
                           
                         
                         
                       }
                               
                       
                        Spacer(minLength: 100)
                    }.coordinateSpace(name: "scroll")
           
                BottomBar()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                        ToolbarItem(placement: .principal) {
                            HStack {
                                Image(systemName: "arrow.backward")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundStyle(.white)
                                    .frame(width: 20,height: 20)
                                   
                                Spacer()
                                HStack{
                                    showImage ?   Image("profile").resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 30, height: 30)
                                        .clipShape(Circle())
                                        .padding(.all,10)
                                        .opacity(showImage ? 1 : 0) : nil
                                    
                                    Text("Rose BlackPink")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                }
                                Spacer()
                                Image(systemName: "person.circle")
                                       .foregroundColor(.white)
                                   
                            }
                        }
            }
                
            
        }
        
    }
}

struct BottomBar:View
{
    var body: some View{
        
        HStack(spacing:15){
            VStack{
                Image(systemName: "megaphone").resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18, height: 18)
                    .foregroundColor(.white)
                
                Text("Fan Club")
                    .font(.system(size: 15))
                    .foregroundColor(.white)
            }
            Divider()
                .frame(height: 30)
                .background(.white)
            VStack{
                Image(systemName: "video").resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18, height: 18)
                    .foregroundColor(.white)
                
                Text("Video Call")
                    .font(.system(size: 15))
                    .foregroundColor(.white)
            }
            Divider()
                .frame(height: 30)
                .background(.white)

            VStack{
                Image(systemName: "paperplane").resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18, height: 18)
                    .foregroundColor(.white)
                
                Text("Direct")
                    .font(.system(size: 15))
                    .foregroundColor(.white)
            }
            Divider()
                .frame(height: 30)
                .background(.white)
            VStack{
                Image(systemName: "phone").resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18, height: 18)
                    .foregroundColor(.white)
                
                Text("Direct")
                    .font(.system(size: 15))
                    .foregroundColor(.white)
            }
            
        }
            
            .frame(width: 350, height: 70)
            .background(Blur(style: .systemThinMaterialDark))
            .cornerRadius(20)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct UserActions:View{
    var body: some View{
        HStack(spacing: 30){
            Button {
               print("show more details")
            } label: {
                Text("Subscribe")
                    .foregroundColor(.white)
                    .frame(width: 150, height: 60)
                    .background(.yellow)
                    .cornerRadius(20)
            }
      
            Button {
               print("Follow")
            } label: {
                ZStack{
                    
                    Text("Follow")
                        .foregroundColor(.white)
                        .frame(width: 150, height: 60)
                    
                        .background(Blur(style: .systemChromeMaterialDark))
                        .cornerRadius(20)
                }
                
            }
        }
    }
}

struct UserDetail:View{
    var body: some View{
        VStack(spacing:10){
            Text("Rose BlackPink").foregroundColor(.white).fontWeight(.medium).font(.system(size: 25))
            Text("Women and girls clothing store. The best quality and high variety, variety of goods")
                .foregroundColor(.white.opacity(0.5)).fontWeight(.medium)
                .multilineTextAlignment(.center)
                .font(.system(size: 13))
        }
    }
}


struct UserInfo:View{
    var body: some View{
        HStack{
            VStack{
                Text("1.5M").foregroundColor(.white).fontWeight(.semibold)
                Text("Followers")
                    .foregroundColor(.white)
                    .fontWeight(.thin)
                    
            }
            Spacer()
            Divider().frame(width: 0.5, height: 30).overlay(.white.opacity(0.3))
          Spacer()
            CustomImage()
            Spacer()
            Divider().frame(width: 0.5, height: 30).overlay(.white.opacity(0.3))
            Spacer()
            VStack{
                Text("1.5M").foregroundColor(.white).fontWeight(.semibold)
                Text("Followers")
                    .foregroundColor(.white)
                    .fontWeight(.thin)
                    
            }
        }
    }
}

struct UserCardPost:View{
    var postDetail:UserPost
    init(postDetail: UserPost) {
        self.postDetail = postDetail
    }
    var body: some View{
        VStack{
           ZStack(alignment:.bottom){
               Text(postDetail.image).foregroundColor(.white)
               Image(postDetail.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 350, maxHeight: 560)
                        .cornerRadius(20)
                        .padding(.top,30)
                    
                    Text("Follow me on GitHub as Makarov96")
                        .foregroundColor(.black.opacity(0.5))
                        .frame(width: 300, height: 30)
                       
                        .background(.white.opacity(0.2))
                        .padding(.bottom, 10)
                        .cornerRadius(20)
                }
          
            
            HStack{
                Image(systemName: "heart").resizable().aspectRatio(contentMode: .fit)
                    .frame(width: 20,height: 20)
                    .foregroundColor(.white.opacity(0.5))
                Text("\(postDetail.likes)K")
                    .foregroundColor(.white.opacity(0.5))
                
                Divider().frame(width: 1, height: 10).overlay(.white.opacity(0.1))
                Image(systemName: "ellipsis.message").resizable().aspectRatio(contentMode: .fit)
                    .frame(width: 20,height: 20)
                    .foregroundColor(.white.opacity(0.5))
                Text("\(postDetail.comments)K")
                    .foregroundColor(.white.opacity(0.5))
                Divider().frame(width: 1, height: 10).overlay(.white.opacity(0.1))
                
                Image(systemName: "paperplane").resizable().aspectRatio(contentMode: .fit)
                    .frame(width: 20,height: 20)
                    .foregroundColor(.white.opacity(0.5))
        
            }.frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 10, leading: 25, bottom: 0, trailing: 0))

        }
    }
}

struct CustomImage:View{
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 90) .stroke(Color.white, lineWidth: 1)
                .foregroundColor(.clear)
                .frame(width: 160, height: 260)
            Image("profile")
            
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 250)
                .clipShape(Capsule())
                .padding(.all,10)
            
            
        }
    }
}


struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemMaterial
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}


class Post: Identifiable {

    
    var uuid: UUID = UUID()
    var urlImage: String
    var type: String
    
    init(urlImage: String, type: String) {
        self.urlImage = urlImage
        self.type = type
    }
}

func getPosts() -> [Post] {
    let posts = [
        Post(urlImage: "https://img.freepik.com/free-photo/full-length-portrait-happy-excited-girl-bright-colorful-clothes-holding-shopping-bags-while-standing-showing-peace-gesture-isolated_231208-5946.jpg", type: "Shop"),
        Post(urlImage: "https://img.freepik.com/premium-photo/ballerina-tutu-posing-standing-near-wall-beautiful-young-woman-black-dress-pointe-dancing-outside-gorgeous-ballerina-performing-dance-outdoors_182067-1292.jpg", type: "Dance"),
        Post(urlImage: "https://www.panaprium.com/cdn/shop/articles/how_dress_like_artist_aesthetic_1000.jpg", type: "Art"),
        Post(urlImage: "https://images.pexels.com/photos/7382411/pexels-photo-7382411.jpeg", type: "Music"),
        Post(urlImage: "https://i.pinimg.com/564x/e5/d8/38/e5d8389ad65468b1ce27048b2c47efff.jpg", type: "Random")
    ]
    return posts
}

class Utils:ObservableObject{
    
    @Published var currentIndex = 0;
    func getIndex(outside inside:Post) {
       let post = getPosts()
        currentIndex = post.firstIndex(where: {$0.id == inside.id})!
        
   }
}

struct UserHistories: View{
    var post: Array<Post>
    @StateObject var utils:Utils = Utils()
    init(post: Array<Post>) {
        self.post = post
    }
    var body: some View{
        ScrollView(.horizontal, showsIndicators: false){
            HStack{
                ForEach(post.indices, id: \.self){
                 index in
                    
                    VStack{
                        AsyncImage(url: URL(string: post[index].urlImage)){
                            image in
                            image.image?
                                .resizable().aspectRatio(contentMode: .fill).frame(width: 50, height: 50).clipShape(Circle())
                        }
                        Text(post[index].type).foregroundColor(.white)
                            .fontWeight(.medium)
                    }.padding([.trailing, .leading], 10)
                        .onTapGesture {
                            utils.getIndex(outside: post[index])
                        }
                }
            }
        }
    }
}



class UserPost: Identifiable{
    
    var uuid: UUID = UUID()
    var image:String
    var comments: Int
    var likes:Int
    
    init(image: String, comments: Int, likes: Int) {
        self.image = image
        self.comments = comments
        self.likes = likes
    }
}

func getUsersPost()->[UserPost]{
    let userPost = [
        UserPost(image: "apple-vision", comments: 50, likes: 200),
       UserPost(image: "aple-watch-ultra", comments: 70, likes: 10),
       UserPost(image: "airpod-max", comments: 30, likes: 35),
       UserPost(image: "airpods", comments: 90, likes: 75),
       
    ]
    
    return userPost;
}






struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}
