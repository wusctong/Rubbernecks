//
//  AdviceView.swift
//  Rubbernecks
//
//  Created by 吴曈 on 2024/4/19.
//

import SwiftUI



var adviceBoardList: [AdviceBoard] = [
    AdviceBoard(user: userList["little_onion"]!, title: "垃圾站周围太脏、太臭了！", content: "上周末我去倒垃圾，天呐！看守的人不知所踪，垃圾堆满地，太可怕了！！！", color: .teal, statement: 2, vote: 5),
    AdviceBoard(user: userList["grandma_qian"]!, title: "电梯里有人乱扔垃圾吔！", content: "每天晚上坐电梯，都能看到一个垃圾袋在电梯间里！太恶心了。希望物业能改善一下，谢谢。", color: .mint, statement: 0, vote: 3)
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
    var vote: Int
}

struct SingleAdviceBoardView: View {
    @State var adviceBoard: AdviceBoard
    
    @State private var isOpened: Bool = false
    @State private var isVoted: Bool = false
    
    var body: some View {
        ZStack {
            Rectangle().fill(adviceBoard.color)
            VStack(alignment: .leading) {
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
                    RoundedRectangle(cornerRadius: 13).fill(.white.opacity(0.3)).frame(height: isOpened ? 90 : 70)
                    HStack {
                        Text("热度：").font(.title3).fontWeight(.regular)
                        Text("\(adviceBoard.vote)").contentTransition(.numericText()).font(.largeTitle).bold()
                        Spacer()
                        Image(systemName: "suit.heart").imageScale(.large).padding(.horizontal, 30).padding(.vertical, 10)
                            .overlay(content: {
                                RoundedRectangle(cornerRadius: 11).fill(adviceBoard.color)
                                Image(systemName: isVoted ? "suit.heart.fill" : "suit.heart").imageScale(.large).scaleEffect(isVoted ? 1.4 : 1).foregroundStyle(.white)
                            })
                            .onTapGesture {
                                withAnimation(.bouncy) {
                                    isVoted.toggle()
                                    adviceBoard.vote += isVoted ? 1 : -1
                                }
                            }
                    }.offset(y: 1).padding(20)
                }.frame(height: isOpened ? 90 : 70).padding(.horizontal, 5)
                ZStack {
                    RoundedRectangle(cornerRadius: 13).fill(.white.opacity(0.35)).frame(height: isOpened ? 126 + 20 * CGFloat(adviceBoard.content.count) / 16 : 82)
                    VStack {
                        HStack {
                            Text("状态：" + STATEMENT_DESCRIBE[adviceBoard.statement]).bold().font(.title3)
                            Spacer()
                        }.padding(.bottom, isOpened ? 20 : 10)
                        HStack {
                            Text(adviceBoard.content).font(.title3)
                            Spacer(minLength: 0)
                        }
                    }.padding(5)
                }.frame(height: isOpened ? 126 + 17 * CGFloat(adviceBoard.content.count) / 14 : 82).padding(.horizontal, 5)
            }
        }.frame(height: isOpened ? 100 + 295 + 17 * CGFloat(adviceBoard.content.count) / 14 : 260 + 70).clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

struct AdviceView: View {
    @State var boardList: [AdviceBoard]
    
    @State var tmpAdviceBoard: AdviceBoard = AdviceBoard(user: currentUser, title: "", content: "", statement: 0, vote: 0)
    @State private var tmpAdviceTitle: String = ""
    @State private var tmpAdviceContent: String = ""
    @State private var tmpAdviceColor: Color = .pink
    @State private var isSent: Bool = false
    @State private var isBadBoard: Bool = false
    
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
                Spacer().alert(isPresented: $isBadBoard) {
                    Alert(title: Text("发布错误"), message: Text("填写信息缺失"), dismissButton: Alert.Button.default(Text("继续编辑"), action: {
                        isBadBoard = false
                    }))
                }
                Text("发布").font(.title).bold().padding(.vertical, 10).padding(.horizontal, 30)
                    .alert(isPresented: $isSent) {
                        Alert(title: Text("已发布"), message: Text("已发布建议"), dismissButton: Alert.Button.default(Text("好的"), action: {
                            isSent = false
                        }))
                    }
                    .overlay(content: {
                    RoundedRectangle(cornerRadius: 15).fill(tmpAdviceColor)
                    Text("发布").font(.title).bold().foregroundStyle(.white)
                    })
                    .onTapGesture {
                        if tmpAdviceTitle == "" || tmpAdviceContent == "" {
                            isBadBoard = true
                        } else {
                            tmpAdviceBoard = AdviceBoard(user: currentUser, title: tmpAdviceTitle, content: tmpAdviceContent, color: tmpAdviceColor, statement: 0, vote: 0)
                            boardList.append(tmpAdviceBoard)
                            
                            tmpAdviceTitle = ""
                            tmpAdviceContent = ""
                            tmpAdviceColor = .pink
                            
                            isSent = true
                        }
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
                            Alert(title: Text("已刷新"), message: Text("去看看建议吧"), dismissButton: Alert.Button.default(Text("好的"), action: {
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
    /// SingleAdviceBoardView(adviceBoard: adviceBoardList[0])
    AdviceView(boardList: adviceBoardList)
}
