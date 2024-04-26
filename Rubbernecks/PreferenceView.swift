//
//  PreferenceView.swift
//  Rubbernecks
//
//  Created by 吴曈 on 2024/4/20.
//

import SwiftUI


var currentUser: User = User(name: "游客", age: 1, showage: false, profile: .iconForShow, realName: "游客")

struct PreferenceView: View {
    @State private var refreshViewId = Date().timeIntervalSince1970
    
    @State private var tmpName: String = currentUser.name
    @State private var tmpAge: Int = currentUser.age
    @State private var tmpShowage: Bool = currentUser.showage
    @State private var tmpProfile: UIImage? = currentUser.profile
    @State private var tmpRealName: String = currentUser.realName
    
    @State private var showImagePicker: Bool = false
    @State private var isRead: Bool = false
    
    var body: some View {
        Preference()
    }
    
    
    func Preference() -> some View {
        VStack {
            HStack {
                Text("设置").font(.largeTitle).bold()
                Spacer()
            }.padding(.horizontal, 20).padding(.top, 20)
            UserInput().id(refreshViewId)
        }
    }
    
    func UserInput() -> some View {
        List {
            HStack {
                Spacer()
                if tmpProfile != nil {
                    Image(uiImage: tmpProfile!).resizable().aspectRatio(contentMode: .fill).frame(width: 150, height: 150).clipShape(.circle)
                        .onTapGesture {
                        showImagePicker = true
                        }.sheet(isPresented: $showImagePicker, content: {
                            ImagePicker(image: $tmpProfile)
                        })
                } else {
                    Text("选择图片")
                }
                Spacer()
            }
            HStack {
                Text("用户名")
                Spacer()
                TextField("", text: $tmpName).frame(width: 100)
            }
            HStack {
                Text("年龄")
                Spacer()
                Text("\(tmpAge)")
                Stepper(value: $tmpAge, label: {
                    Text("")
                }).frame(width: 100)
            }
            HStack {
                Text("显示年龄")
                Spacer()
                Toggle(isOn: $tmpShowage, label: {})
            }
            HStack {
                Text("真名")
                Spacer()
                TextField("", text: $tmpRealName).frame(width: 100)
            }
            HStack {
                Spacer()
                Text((currentUser.name != tmpName || currentUser.age != tmpAge || currentUser.profile != tmpProfile || currentUser.showage != tmpShowage || currentUser.realName != tmpRealName) ? "保存结果" : "未修改").padding(.vertical, 10).padding(.horizontal, 30).bold()
                    .overlay(content: {
                        RoundedRectangle(cornerRadius: 13).fill(.accent)
                        Text((currentUser.name != tmpName || currentUser.age != tmpAge || currentUser.showage != tmpShowage || currentUser.profile != tmpProfile || currentUser.realName != tmpRealName) ? "保存结果" : "未修改").foregroundStyle(.white).bold()
                    })
                    .onTapGesture {
                        currentUser = User(name: tmpName, age: tmpAge, showage: tmpShowage, profile: tmpProfile!, realName: tmpRealName)
                        refresh()
                    }
            }
        }
    }
    
    private func refresh() {
        refreshViewId = Date().timeIntervalSince1970
    }
}

#Preview {
    PreferenceView()
}
