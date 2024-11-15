//
//  WelcomeView.swift
//  QuickMaths
//
//  Created by Taylor Tran on 9/26/24.
//

import SwiftUI
import RealityKit
import Combine

struct WelcomeView: View {
    @State private var chosenTime: String = "60"
    @State private var chosenDifficulty: Int = 1
    @State private var questionCount: Int = 10
    
    @State private var isGameViewActive = false
    @State private var gameViewModel: GameViewModel?
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var isPopover: Bool = false
    @FocusState private var isInputActive: Bool // Track focus for TextFields
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isInputActive = false // Dismiss keyboard on tap
                }
            
            RealityKitView()
                .edgesIgnoringSafeArea(.all)
                .opacity(0.3)
            
            VStack {
                HStack {
                    Button {
                        withAnimation {
                            isPopover.toggle()
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.green)
                    }
                    Spacer()
                }
                
                Spacer()
                
                Text("HackerMath")
                    .font(.custom("Courier", size: 50))
                    .foregroundColor(.green)
                    .shadow(color: .green, radius: 5, x: 0, y: 0)
                    .modifier(GlitchEffect())
                
                Spacer()
                
                VStack(spacing: 15) {
                    HStack {
                        Text("Timer:")
                            .font(.custom("Courier", size: 18))
                            .foregroundColor(.green)
                        TextField("Time", text: $chosenTime)
                            .multilineTextAlignment(.center)
                            .frame(width: 80, height: 40)
                            .background(Color.black)
                            .foregroundColor(.green)
                            .cornerRadius(5)
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.green, lineWidth: 1))
                            .keyboardType(.numberPad)
                            .focused($isInputActive)
                            .onChange(of: chosenTime) { newValue in
                                chosenTime = newValue.filter { "0123456789".contains($0) }
                            }
                    }
                    
                    HStack {
                        Text("Difficulty:")
                            .font(.custom("Courier", size: 18))
                            .foregroundColor(.green)
                        HStack(spacing: 10) {
                            ForEach(1...5, id: \.self) { level in
                                Button(action: {
                                    chosenDifficulty = level
                                }) {
                                    Text("\(level)")
                                        .font(.custom("Courier", size: 18))
                                        .foregroundColor(chosenDifficulty == level ? .black : .green)
                                        .frame(width: 30, height: 30)
                                        .background(
                                            Circle()
                                                .fill(chosenDifficulty == level ? Color.green : Color.black)
                                        )
                                        .overlay(
                                            Circle()
                                                .stroke(Color.green, lineWidth: chosenDifficulty == level ? 2 : 1)
                                        )
                                        .animation(.easeInOut(duration: 0.2), value: chosenDifficulty)
                                }
                            }
                        }
                        .padding(.vertical, 5)
                        .background(Color.black)
                        .cornerRadius(5)
                    }
                    .padding()
                    .background(Color.black)
                    .cornerRadius(5)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.green, lineWidth: 1))
                    
                    HStack {
                        Text("Questions:")
                            .font(.custom("Courier", size: 18))
                            .foregroundColor(.green)
                        TextField("Number", value: $questionCount, formatter: NumberFormatter())
                            .multilineTextAlignment(.center)
                            .frame(width: 80, height: 40)
                            .background(Color.black)
                            .foregroundColor(.green)
                            .cornerRadius(5)
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.green, lineWidth: 1))
                            .keyboardType(.numberPad)
                            .focused($isInputActive)
                            .onChange(of: questionCount) { newValue in
                                questionCount = newValue > 0 ? newValue : questionCount
                            }
                    }
                }
                
                if chosenDifficulty == 1 {
                    difficultyText("Elementary School Level")
                } else if chosenDifficulty == 2 {
                    difficultyText("Middle School Level")
                } else if chosenDifficulty == 3 {
                    difficultyText("Highschool Level")
                } else if chosenDifficulty == 4 {
                    difficultyText("College Level")
                } else if chosenDifficulty == 5 {
                    difficultyText("Math Olympiad Level")
                }
                
                Spacer()
                
                Button("Start Game") {
                    if questionCount <= 0 {
                        alertMessage = "Please enter a valid question count greater than 0."
                        showAlert = true
                    } else if Int(chosenTime) ?? 0 <= 0 {
                        alertMessage = "Please enter a valid timer value greater than 0."
                        showAlert = true
                    } else {
                        gameViewModel = GameViewModel(
                            timer: Int(chosenTime) ?? 60,
                            difficulty: chosenDifficulty,
                            questionCount: questionCount
                        )
                        isGameViewActive = true
                    }
                }
                .font(.custom("Courier", size: 18))
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .foregroundColor(.black)
                .cornerRadius(5)
                .padding(.horizontal, 50)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Invalid Input"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                
                NavigationLink(
                    destination: GameView(isGameViewActive: $isGameViewActive)
                        .environmentObject(gameViewModel ?? GameViewModel(difficulty: 1, questionCount: 10)),
                    isActive: $isGameViewActive,
                    label: { EmptyView() }
                )
                
                Spacer()
            }
            .padding()
            GeometryReader { geometry in
                if isPopover {
                    Color.black.opacity(0.6)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.3), value: isPopover)
                        .onTapGesture {
                            withAnimation {
                                isPopover = false
                            }
                        }
                    
                    HStack(spacing: 0) {
                        VStack {
                            Text("More Games")
                                .font(.custom("Courier", size: 24))
                                .foregroundColor(.green)
                                .padding(.top, 50)
                            
                            Button("80-in-8") {
                                print("80-in-8 selected")
                            }
                            .font(.custom("Courier", size: 18))
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.green)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .padding(.top, 15)
                            
                            Button("Game 2") {
                                print("Game 2 selected")
                            }
                            .font(.custom("Courier", size: 18))
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.green)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .padding(.top, 10)
                            
                            Button("Game 3") {
                                print("Game 3 selected")
                            }
                            .font(.custom("Courier", size: 18))
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.green)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .padding(.top, 10)
                            
                            Spacer()
                        }
                        .frame(width: geometry.size.width * 0.5)
                        .background(Color.black)
                        .cornerRadius(15)
                        .shadow(radius: 10)
                        
                        Spacer()
                    }
                    .transition(.move(edge: .leading))
                    .animation(.easeInOut(duration: 0.3), value: isPopover)
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    // Function to format text based on input
    func difficultyText(_ text: String) -> some View {
        TypingTextView(text: text)
    }
}

struct TypingTextView: View {
    let text: String
    @State private var displayedText = ""
    private let typingSpeed = 0.05  // Adjust speed for typing effect

    var body: some View {
        Text(displayedText)
            .font(.custom("Courier", size: 16))
            .foregroundColor(.green)
            .multilineTextAlignment(.center)
            .padding(.top, 10)
            .onAppear {
                displayedText = ""  // Start with an empty string
                var currentIndex = 0

                Timer.scheduledTimer(withTimeInterval: typingSpeed, repeats: true) { timer in
                    if currentIndex < text.count {
                        let index = text.index(text.startIndex, offsetBy: currentIndex)
                        displayedText += String(text[index])
                        currentIndex += 1
                    } else {
                        timer.invalidate()  // Stop the timer when done
                    }
                }
            }
    }
}

// Glitch Effect Modifier
struct GlitchEffect: ViewModifier {
    func body(content: Content) -> some View {
        content
            .overlay(
                content
                    .foregroundColor(.green.opacity(0.8))
                    .offset(x: 1, y: 1)
                    .blendMode(.difference)
            )
            .overlay(
                content
                    .foregroundColor(.green.opacity(0.5))
                    .offset(x: -1, y: -1)
                    .blendMode(.difference)
            )
    }
}

// RealityKitView for the rotating 3D model background
struct RealityKitView: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        // Load the .usdz model
        if let modelEntity = try? Entity.loadModel(named: "polyhedron") {
            modelEntity.scale = SIMD3<Float>(repeating: 0.5) // Adjust the size if needed
            modelEntity.position = SIMD3<Float>(0, 0, -40) // Position it farther back in the scene
            
            // Apply neon green color
            let neonGreenMaterial = SimpleMaterial(color: .green, isMetallic: false)
            modelEntity.model?.materials = [neonGreenMaterial]

            // Add the model entity to the ARView
            let anchorEntity = AnchorEntity(world: .zero)
            anchorEntity.addChild(modelEntity)
            arView.scene.addAnchor(anchorEntity)

            // Set up smooth rotation on multiple axes
            arView.scene.subscribe(to: SceneEvents.Update.self) { event in
                let deltaTime = Float(event.deltaTime)
                
                // Slow, smooth random rotation on multiple axes
                let rotationX = deltaTime * .pi / 32
                let rotationY = deltaTime * .pi / 24
                let rotationZ = deltaTime * .pi / 36
                
                modelEntity.transform.rotation *= simd_quatf(angle: rotationX, axis: SIMD3<Float>(1, 0, 0))
                modelEntity.transform.rotation *= simd_quatf(angle: rotationY, axis: SIMD3<Float>(0, 1, 0))
                modelEntity.transform.rotation *= simd_quatf(angle: rotationZ, axis: SIMD3<Float>(0, 0, 1))
            }.store(in: &context.coordinator.cancellables)
        }
        
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}
    
    // Coordinator for managing subscriptions
    class Coordinator {
        var cancellables: Set<AnyCancellable> = []
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
}

#Preview {
    NavigationView {
        WelcomeView()
    }
    .environmentObject(GameViewModel(
        difficulty: 1,
        questionCount: 10)
    )
}
