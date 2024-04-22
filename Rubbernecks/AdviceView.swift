//
//  AdviceView.swift
//  Rubbernecks
//
//  Created by 吴曈 on 2024/4/19.
//

import SwiftUI



var adviceBoardList: [AdviceBoard] = [ AdviceBoard(user: userList["little_onion"]!, title: "垃圾站周围太脏、太臭了！", content: "上周末我去倒垃圾，天呐！看守的人不知所踪，垃圾堆满地，太可怕了！！！", color: .teal, statement: 2), AdviceBoard(user: userList["grandma_qian"]!, title: "电梯里有人乱扔垃圾吔！", content: "每天晚上坐电梯，都能看到一个垃圾袋在电梯间里！太恶心了。希望物业能改善一下，谢谢。", color: .mint, statement: 0) ]

var adviceVoteList: [AdviceBoard: Int] = [
    adviceBoardList[0]: 5,
    adviceBoardList[1]: 3
]

let STATEMENT_DESCRIBE: [String] = ["正在审阅中", "审阅完毕", "正在调查中", "调查完毕", "已解决"]

let bigNumber: Font = Font.custom("bigNumber", size: 60)


struct AdviceBoard: Hashable, Identifiable {
    let id = UUID()
    var user: User!
    var title: String
    var content: String
    var color = Color.pink
    var statement: Int
}

struct SingleAdviceBoardView: View {
    var adviceBoard: AdviceBoard
    
    @State private var isOpened: Bool = false
    
    var body: some View {
        ZStack {
            Rectangle().fill(adviceBoard.color)
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 13).fill(adviceBoard.color).padding(5)
                    HStack {
                        Text(adviceBoard.title).font(.title).bold()
                        Spacer()
                        Text(adviceBoard.user.name).font(.title2)
                    }.padding(10)
                }.frame(height: 150)
                    .onTapGesture {
                        withAnimation(.bouncy) {
                            isOpened.toggle()
                        }
                    }
                ZStack {
                    RoundedRectangle(cornerRadius: 13).fill(.white.opacity(0.35))
                    VStack {
                        HStack {
                            Text("状态：" + STATEMENT_DESCRIBE[adviceBoard.statement]).bold().font(.title3).padding(5)
                            Spacer()
                        }
                        HStack {
                            Text(adviceBoard.content).font(.title3).padding(5)
                            Spacer(minLength: 0)
                        }
                    }
                }.frame(height: isOpened ? 160 + 17 * CGFloat(adviceBoard.content.count) / 14 : 60).padding(5)
            }
        }.frame(height: isOpened ? 350 + 17 * CGFloat(adviceBoard.content.count) / 14 : 245).clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

struct AdviceView: View {
    @State var boardList: [AdviceBoard]
    @State var voteMapping: [AdviceBoard: Int]
    
    @State var tmpAdviceBoard: AdviceBoard = AdviceBoard(user: currentUser, title: "", content: "", statement: 0)
    @State private var tmpAdviceTitle: String = ""
    @State private var tmpAdviceContent: String = ""
    @State private var tmpAdviceColor: Color = .pink
    @State private var isSent: Bool = false
    
    @State private var isRefreshed: Bool = false
    @State private var refreshViewId = Date().timeIntervalSince1970
    
    var body: some View {
        AdviceList(boardList: boardList)
    }
    
    
    func AdviceInput() -> some View {
        VStack {
            TextField("标题", text: $tmpAdviceTitle).font(.largeTitle).bold().padding(5)
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 15).stroke(tmpAdviceColor, lineWidth: 2)
            })
            HStack {
                ColorPicker(selection: $tmpAdviceColor, label: {
                    Text("建议板颜色").font(.title2).foregroundStyle(tmpAdviceColor)
                })
                Spacer()
                Text("发布").font(.title).bold().padding(.vertical, 10).padding(.horizontal, 30)
                    .alert(isPresented: $isSent) {
                        Alert(title: Text("已发布"), message: Text("已发布建议"), dismissButton: Alert.Button.default(Text("知道了"), action: {
                            isSent = false
                        }))
                    }
                    .overlay(content: {
                    RoundedRectangle(cornerRadius: 15).fill(tmpAdviceColor)
                    Text("发布").font(.title).bold().foregroundStyle(.white)
                    })
                    .onTapGesture {
                        tmpAdviceBoard = AdviceBoard(user: currentUser, title: tmpAdviceTitle, content: tmpAdviceContent, color: tmpAdviceColor, statement: 0)
                        boardList.append(tmpAdviceBoard)
                        voteMapping[tmpAdviceBoard] = 0
                        
                        tmpAdviceTitle = ""
                        tmpAdviceContent = ""
                        tmpAdviceColor = .pink
                        
                        isSent = true
                    }
            }
            TextEditor(text: $tmpAdviceContent).padding(5)
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 15).stroke(tmpAdviceColor, lineWidth: 2)
                })
        }.id(refreshViewId)
    }
    
    func AdviceList(boardList: [AdviceBoard]) -> some View {
        NavigationSplitView {
            VStack {
                HStack {
                    Text("建议区").font(.largeTitle).bold()
                    Spacer()
                    Spacer()
                    Image(systemName: "plus.app").imageScale(.large).padding(.horizontal, 20).padding(.vertical, 10)
                        .overlay(content: {
                            RoundedRectangle(cornerRadius: 15).fill(.accent)
                            Text("刷新").font(.title3).fontWeight(.medium).foregroundStyle(.white)
                        })
                        .alert(isPresented: $isRefreshed) {
                            Alert(title: Text("已刷新"), message: Text("去看看建议吧"), dismissButton: Alert.Button.default(Text("好的呢"), action: {
                                isRefreshed = false
                            }))
                        }
                        .onTapGesture {
                            refresh()
                            isRefreshed = true
                        }
                    
                    NavigationLink {
                        AdviceInput().padding(.horizontal, 20)
                    } label: {
                        Image(systemName: "plus.app").imageScale(.large).padding(.horizontal, 30).padding(.vertical, 10)
                            .overlay(content: {
                                RoundedRectangle(cornerRadius: 15).fill(tmpAdviceColor)
                                Image(systemName: "plus.app").imageScale(.large).foregroundStyle(.white)
                            })
                    }
                    
                }.padding(.horizontal, 20).padding(.top, 20)
                SwiftUI.ScrollView {
                    ForEach(boardList.reversed()) { board in
                        SingleAdviceBoardView(adviceBoard: board).padding(.vertical, 5)
                    }
                }.padding(.horizontal, 20)
            }
        } detail: {
            Text("看看建议")
        }
    }
    
    
    func refresh() {
        refreshViewId = Date().timeIntervalSince1970
    }
}

#Preview {
    // SingleAdviceBoardView(adviceBoard: adviceBoardList[0])
    AdviceView(boardList: adviceBoardList, voteMapping: adviceVoteList)
}
