//
//  ToastViewModifier.swift
//  Swiggy_Task
//
//  Created by abhinay varma on 02/02/25.
//
import SwiftUI
struct ToastModifier: ViewModifier {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var isShowing: Bool
    let message: String
    let duration: TimeInterval
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isShowing {
                VStack {
                    Spacer()
                    Text(message)
                        .font(.headline)
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .foregroundColor(themeManager.selectedTheme.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.easeInOut(duration: 0.3), value: isShowing)
                        .padding(.bottom, 50) // Adjust the position
                }
                .zIndex(1)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        isShowing = false
                    }
                }
            }
        }
    }
}

extension View {
    func toast(isShowing: Binding<Bool>, message: String, duration: TimeInterval = 2) -> some View {
        self.modifier(ToastModifier(isShowing: isShowing, message: message, duration: duration))
    }
}
