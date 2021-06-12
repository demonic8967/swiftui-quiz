//
//  ContentView.swift
//  QuizApp
//
//  Created by Porridge on 5/6/21.
//

import SwiftUI

struct ContentView: View {
    
    var questions = [Question(title: "What day is it?",
                              option1: "Monday",
                              option2: "Saturday",
                              option3: "Wednesday",
                              option4: "Friday"),
                     Question(title: "What framework are we using?",
                              option1: "UIKit",
                              option2: "SwiftUI",
                              option3: "React Native",
                              option4: "Flutter"),
                     Question(title: "Which company created Swift?",
                              option1: "Google",
                              option2: "Apple",
                              option3: "Pear",
                              option4: "Tinkercademy"),
                     Question(title: "When is the end of the world?",
                              option1: "Tomorrow",
                              option2: "You wouldn't live to see it",
                              option3: "I don't care",
                              option4: "The world is immortal"),
                     Question(title: "Never?",
                              option1: "Gonna",
                              option2: "Give",
                              option3: "You",
                              option4: "Up"),
                     Question(title: "What is the best version of Never Gonna Give You Up?",
                              option1: "The Original",
                              option2: "Earrape",
                              option3: "Silence",
                              option4: "Remixed"),
                     Question(title: "How much money do you have on you?",
                              option1: "Why you asking me?",
                              option2: "I'm broke",
                              option3: "Ya need cash bro?",
                              option4: "$10")]

    @State var currentQuestion = 0

    @State var isAlertPresented = false
    @State var isCorrect = false

    @State var correctAnswers = 0
    @State var isModalPresented = false

    // State variables for Animations
    @State var punchlineSize: CGFloat = 0.1
    @State var punchlineRotation: Angle = .zero
    @State var opacity: Double = 0
    @State var tapToContinueOffset: CGFloat = 50
    @State var resetTitle = true
    var body: some View {
        ZStack {
            Color.yellow
                .ignoresSafeArea()
            VStack {
                Text("You have 3 seconds to answer this question!").font(.system(size: 40)).multilineTextAlignment(.center).lineLimit(nil).padding()
                

                if resetTitle {
                    Text(questions[currentQuestion].title)
                        .font(.system(size: 24))
                        .lineLimit(nil)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.blue)
                        .padding()
                        .scaleEffect(punchlineSize)
                        .rotationEffect(punchlineRotation)
                        .opacity(opacity)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1.0)) {
                                punchlineSize = 1
                                punchlineRotation = Angle(degrees: 360 * 2)
                                opacity = 1
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    resetTitle = false
                                }
                            }
                        }
                        .onDisappear {
                            punchlineSize = 0.1
                            punchlineRotation = .zero
                            opacity = 0
                        }
                }
                HStack {
                    VStack {
                        Button(questions[currentQuestion].option1) {
                            didTapOption(optionNumber: 1)
                        }.frame(width: 150).padding().background(Color.blue).foregroundColor(Color.white).cornerRadius(10).padding().multilineTextAlignment(.center)
                        Button(questions[currentQuestion].option2) {
                            didTapOption(optionNumber: 2)
                        }.frame(width: 150).padding().background(Color.blue).foregroundColor(Color.white).cornerRadius(10).padding().multilineTextAlignment(.center)
                    }
                    VStack {
                        Button(questions[currentQuestion].option3) {
                            didTapOption(optionNumber: 3)
                        }.frame(width: 150).padding().background(Color.blue).foregroundColor(Color.white).cornerRadius(10).padding().multilineTextAlignment(.center)
                        Button(questions[currentQuestion].option4) {
                            didTapOption(optionNumber: 4)
                        }.frame(width: 150).padding().background(Color.blue).foregroundColor(Color.white).cornerRadius(10).padding().multilineTextAlignment(.center)
                    }
                }
                .padding()
            }
            
            .alert(isPresented: $isAlertPresented) {
                Alert(title: Text(isCorrect ? "Correct" : "Wrong"),
                      message: Text(isCorrect ? "Congrats, you are kinda smart." : "This is outrageous, with such easy questions, how can you be getting this wrong?!"),
                      dismissButton: .default(Text("OK")) {
                        currentQuestion += 1
                        resetTitle = true
                        
                        if currentQuestion == questions.count {
                            isModalPresented = true
                            currentQuestion = 0
                        }
                      })
            }
            .sheet(isPresented: $isModalPresented,
                   onDismiss: {
                    correctAnswers = 0
                   },
                   content: {
                    ScoreView(score: correctAnswers, totalQuestions: questions.count)
                   })
        }
    }
    
    func didTapOption(optionNumber: Int) {
        if optionNumber == 2 {
            print("Correct")
            isCorrect = true
            correctAnswers += 1
        } else {
            print("Wrong")
            isCorrect = false
        }
        isAlertPresented = true
    }
}

struct ContentView_Previews: PreviewProvider {
    @State private var timeRemaining = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    static var previews: some View {
        ContentView()
    }
}
