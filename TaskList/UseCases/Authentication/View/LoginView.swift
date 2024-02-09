//
//  LoginView.swift
//  TaskList
//
//  Created by Nicolas Santiago on 06-02-24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack(alignment: .leading) {
                    Image("bgLogin")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    
                    VStack(alignment: .leading) {
                        Text("Hello")
                            .font(.custom("", size: 45))
                            .foregroundStyle(.white)
                        Text("Again!")
                            .font(.custom("", size: 45))
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal)
                }
                .ignoresSafeArea(.all)
                
                VStack(spacing: 60) {
                    VStack(spacing: 40) {
                        VStack(spacing: 20) {
                            TextField("", text: $email, prompt: Text("Email")
                                .foregroundColor(.gray))
                            .font(.headline)
                            .foregroundColor(.gray)
                            .textInputAutocapitalization(.never)

                            Divider()
                                .frame(height: 2)
                                .background(Color.gray.opacity(0.4))
                        }
                        
                        VStack(spacing: 20) {
                            SecureField("", text: $password, prompt: Text("Password")
                                .foregroundColor(.gray))
                            .font(.headline)
                            .foregroundStyle(.gray)
                            .textInputAutocapitalization(.never)

                            Divider()
                                .frame(height: 2)
                                .background(Color.gray.opacity(0.4))
                        }
                    }
                    
                    
                    HStack {
                        Spacer()
                        ZStack {
                            Circle()
                                .frame(width: 50, height: 50)
                                .foregroundStyle(Color("yellow"))
                            Button(action: {
                                Task {
                                    try await viewModel.signIn(withEmail: email , password: password)
                                }
                            }, label: {
                                Text("Login")
                                    .font(.largeTitle)
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    .foregroundStyle(.black)
                            })
                        }
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: {
                        RegisterView()
                            .navigationBarBackButtonHidden()
                    }, label: {
                        HStack(spacing: 0) {
                            Text("Don't have an acccount? ")
                                .foregroundStyle(.gray)
                                .font(.subheadline)

                            Text(" Register")
                                .foregroundStyle(.black)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .font(.subheadline)
                        }
                    })
                }
                .padding(.horizontal)
            }
            
        }
    }
}

#Preview {
    LoginView()
}
