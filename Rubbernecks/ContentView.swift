//
//  ContentView.swift
//  Rubbernecks
//
//  Created by wutong on 4/17/2024.
//

import SwiftUI



/// Main View
struct ContentView: View {
    let views: [any View] = [
        GrossipView(boardList: grossipBoardList, commentMapping: grossipCommentList),
        AdviceView(boardList: adviceBoardList),
        PreferenceView()
    ]
    @State var currentViewIndex: Int = 0
    @State var currentView: any View = GrossipView(boardList: grossipBoardList, commentMapping: grossipCommentList)
    // Body
    var body: some View {
        VStack {
            AnyView(currentView)
            NavigationMenu()
        }
    }

    
    /// Menu which navigates to different views.
    func NavigationMenu() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: DEFAULT_CORNER_RADIUS)
                .fill(.clear)
                .stroke(.accent, lineWidth: 3)
            HStack {
                singleTab(image: Image(systemName: "person.wave.2"), text: "八卦区", statement: (currentViewIndex == 0))
                    .onTapGesture {
                        currentViewIndex = 0
                        currentView = views[currentViewIndex]
                    }
                singleTab(image: Image(systemName: "bubble.left"), text: "建议区", statement: (currentViewIndex == 1))
                    .onTapGesture {
                        currentViewIndex = 1
                        currentView = views[currentViewIndex]
                    }
                singleTab(image: Image(systemName: "gear"), text: "设置", statement: (currentViewIndex == 2))
                    .onTapGesture {
                        currentViewIndex = 2
                        currentView = views[currentViewIndex]
                    }
            }.padding(.horizontal, 20)
                .padding(.vertical, 10)
        }.padding(.horizontal, 22)
            .padding(.vertical, 10)
            .frame(height: 100)
        /**.tabItem {
            Image(systemName: "person.wave.2")
            Text("八卦区")
        }
        AdviceView(boardList: adviceBoardList).tabItem {
            Image(systemName: "bubble.left")
            Text("建议区")
        }
        PreferenceView().tabItem {
            Image(systemName: "gear")
            Text("设置")
        }**/
    }
    
    func singleTab(image: Image, text: String, statement: Bool = false) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: DEFAULT_CORNER_RADIUS * 0.8)
                .fill(statement ? .accent : .clear)
                .stroke(.accent, lineWidth: 2)
            VStack {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(statement ? .white : .black)
                Text(text)
                    .lineLimit(1)
                    .font(.caption)
                    .foregroundStyle(statement ? .white : .black)
            }.padding(8)
        }
    }
}


#Preview {
    ContentView()
}
