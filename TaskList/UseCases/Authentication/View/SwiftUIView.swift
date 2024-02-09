//
//  SwiftUIView.swift
//  TaskList
//
//  Created by Nicolas Santiago on 08-02-24.
//

import SwiftUI

struct SwiftUIView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        ZStack {
            VStack {
                Image("bgRegister")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)

                Spacer()
            }
            VStack {
                Spacer()

                VStack(alignment: .leading, spacing: 20) {
                    Text("Create")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    Text("Account")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                }

                VStack(spacing: 20) {
                    TextField("Full Name", text: $fullName)
                        .foregroundStyle(.black)
                        .frame(height: 45)
                        .padding(.horizontal)
                        .background(
                            Rectangle()
                                .foregroundStyle(.gray.opacity(0.3))
                        )
                    TextField("Email", text: $email)
                        .foregroundStyle(.black)
                        .frame(height: 45)
                        .padding(.horizontal)
                        .background(
                            Rectangle()
                                .foregroundStyle(.gray.opacity(0.3))
                        )
                    SecureField("Password", text: $password)
                        .foregroundStyle(.black)
                        .frame(height: 45)
                        .padding(.horizontal)
                        .background(
                            Rectangle()
                                .foregroundStyle(.gray.opacity(0.3))
                        )
                }
                .padding(.horizontal)
                
                Button(action: {
                    Task {
                        try await authViewModel.createUser(withEmail: email, password: password, fullName: fullName)
                    }
                }) {
                    Text("Login")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                }
                .frame(width: 200, height: 50)
                .background(
                    Circle()
                        .foregroundStyle(Color("yellow"))
                )

                Spacer()
                
                NavigationLink(destination: {
                    RegisterView()
                        .navigationBarBackButtonHidden()
                }) {
                    Text("Don't have an account? Register")
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                }
                .foregroundColor(.black)
            }
            .background(Color.red)
            .safeAreaPadding(.all)
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.all)
    }
}
#Preview {
    SwiftUIView()
}
