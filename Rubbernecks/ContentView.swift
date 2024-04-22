//
//  ContentView.swift
//  Rubbernecks
//
//  Created by wutong on 4/17/2024.
//

import SwiftUI



// Main View
struct ContentView: View {
    // Body
    var body: some View {
        NavigationMenu()
    }

    
    // Menu which navigates to different views.
    func NavigationMenu() -> some View {
        TabView {
            GrossipView(boardList: grossipBoardList, commentMapping: grossipCommentList).tabItem {
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
            }
        }
    }
}


#Preview {
    ContentView()
}
