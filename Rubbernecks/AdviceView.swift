//
//  AdviceView.swift
//  Rubbernecks
//
//  Created by 吴曈 on 2024/4/19.
//

import SwiftUI



var adviceBoardList: [AdviceBoard] = [ AdviceBoard(user: userList["little_onion"]!, title: "垃圾站周围太脏、太臭了！", content: "上周末我去倒垃圾，天呐！看守的人不知所踪，垃圾堆满地，太可怕了！！！", color: .teal, statement: 2), AdviceBoard(user: userList["grandma_qian"]!, title: "电梯里有人乱扔垃圾吔！", content: "每天晚上坐电梯，都能看到一个垃圾袋在电梯间里！太恶心了。希望物业能改善一下，谢谢。", color: .mint, statement: 0) ]

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
                        withAnimation {
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
                }.frame(height: isOpened ? 200 + 17 * CGFloat(adviceBoard.content.count) / 14 : 60).padding(5)
            }
        }.frame(height: isOpened ? 350 + 17 * CGFloat(adviceBoard.content.count) / 14 : 245).clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

struct AdviceView: View {
    var boardList: [AdviceBoard]
    
    var body: some View {
        AdviceBoardList(boardList: boardList)
    }
    
    func AdviceBoardList(boardList: [AdviceBoard]) -> some View {
        VStack {
            HStack {
                Text("建议区").font(.largeTitle).bold()
                Spacer()
            }.padding(.horizontal, 20).padding(.top, 20)
            SwiftUI.ScrollView {
                ForEach(boardList) { adviceBoard in
                    SingleAdviceBoardView(adviceBoard: adviceBoard).padding(.vertical, 5)
                }
            }.padding(.horizontal, 20)
        }
    }
}

#Preview {
    // SingleAdviceBoardView(adviceBoard: adviceBoardList[0])
    AdviceView(boardList: adviceBoardList)
}
