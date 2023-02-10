//
//  ContentView.swift
//  towdays_Timer
//
//  Created by macboy on 2023/02/10.
//

import SwiftUI

struct ContentView: View {
    
    @State var timerHandler: Timer?
    @State var count = 0
    @AppStorage("timer_value") var timerValue = 10
    @State var showAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("backgroundTimer")
                //リサイズする
                    .resizable()
                //セーフエリアを超えて画面全体に配置
                    .edgesIgnoringSafeArea(.all)
                //アスペクト比を維持
                    .aspectRatio(contentMode: .fill)
                VStack(spacing: 30.0) {
                    Text("\(timerValue - count) Seconds left")
                        .font(.largeTitle)
                    
                    HStack {
                        Button(action: {
                            startTimer()
                        }){
                            Text("Start")
                                .font(.title)
                                .foregroundColor(Color.white)
                                .frame(width: 140, height: 140)
                                .background(Color("startColor"))
                                .clipShape(Circle())
                        }
                        Button(action: {
                            if let unwrappedTimerHandler = timerHandler {
                                if unwrappedTimerHandler.isValid == true {
                                    unwrappedTimerHandler.invalidate()
                                }
                            }
                        }){
                            Text("Stop")
                                .font(.title)
                                .foregroundColor(Color.white)
                                .frame(width: 140, height: 140)
                                .background(Color("stopColor"))
                                .clipShape(Circle())
                        }
                    }
                }
            }
            .alert(isPresented: $showAlert){
                Alert(title: Text("END"),
                      message: Text("owari desu"),
                      dismissButton: .default(Text("OK")))
            }
            .onAppear {
                count = 0
            }
            .navigationBarItems(trailing: NavigationLink(destination: SettingView()){
                Text("設定画面")
            })
        }
    }
    
    func countDownTimer(){
        count += 1
        
        if timerValue - count <= 0 {
            // invalidate()　Timerを止める
            timerHandler?.invalidate()
            showAlert = true
        }
    }
    
    func startTimer(){
        if let unwrapedTimerHandler = timerHandler {
            //　もしTimerが実行中だったら
            if unwrapedTimerHandler.isValid == true {
                return
            }
        }
        
        if timerValue - count <= 0 {
            count = 0
        }
        
        // クロージャにTimerが渡されているが使わないので　_ in している
        timerHandler = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){_ in
            // 1秒ごとに実行される関数
            countDownTimer()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
