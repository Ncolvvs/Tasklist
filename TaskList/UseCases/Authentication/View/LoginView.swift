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
                        Text("Hellow")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        Text("Again!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
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
                            
                            Rectangle()
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 2)
                                .foregroundStyle(.gray)
                        }
                        
                        VStack(spacing: 20) {
                            SecureField("", text: $password, prompt: Text("Password")
                                .foregroundColor(.gray))
                            .font(.headline)
                            .foregroundColor(.gray)
                            
                            Rectangle()
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 2)
                                .foregroundStyle(.gray)
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
                            Text("Register")
                                .foregroundStyle(.black)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
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
