//
//  YHKCardView.swift
//  YHealth
//
//  Created by eternity6666 on 2023/10/30.
//

import SwiftUI

struct YHKCardView<Content>: View where Content: View {
    @Binding var isLoading: Bool
    var width = 120.0
    var height = 120.0
    var cornerRadius = 16.0
    var content: Content
    
    var body: some View {
        ZStack {
            if isLoading {
                LoadingView()
            } else {
                content
            }
        }
        .frame(width: width, height: height)
        .background(Color(UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .shadow(radius: 1.5, y: 1)
    }
    
    private struct LoadingView: View {
        @State private var isAnimation = false
        var width = 40.0
        var height = 40.0
        
        var body: some View {
            Image(systemName: "swirl.circle.righthalf.filled")
                .resizable()
                .frame(width: width, height: height)
                .foregroundColor(.green)
                .rotationEffect(
                    .degrees(isAnimation ? 0.0 : 360.0)
                )
                .animation(
                    .easeInOut(duration: 1)
                    .repeatForever(autoreverses: false),
                    value: self.isAnimation
                )
                .onAppear {
                    self.isAnimation.toggle()
                }
        }
    }
}

#Preview {
    VStack {
        YHKCardView(
            isLoading: .constant(true),
            content: Text("测试")
        )
        
        YHKCardView(
            isLoading: .constant(false),
            content: Text("测试")
        )
    }
}
