//
//  RegisterView.swift
//  TaskList
//
//  Created by Nicolas Santiago on 06-02-24.
//

import SwiftUI

struct RegisterView: View {
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
            VStack(spacing: 60) {
                Spacer()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Create")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        Text("Account")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                    }
                    
                    Spacer()
                }
                
                VStack(spacing: 40) {
                    VStack(spacing: 20) {
                        TextField("", text: $fullName, prompt: Text("Name")
                            .foregroundColor(.white))
                        .font(.headline)
                        .foregroundColor(.white)
                        
                        Rectangle()
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 2)
                            .foregroundStyle(.white)
                    }
                    
                    VStack(spacing: 20) {
                        TextField("", text: $email, prompt: Text("Email")
                            .foregroundColor(.white))
                        .font(.headline)
                        .foregroundColor(.white)
                        
                        Rectangle()
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 2)
                            .foregroundStyle(.white)
                    }
                    
                    VStack(spacing: 20) {
                        SecureField("", text: $password, prompt: Text("Password")
                            .foregroundColor(.white))
                        .font(.headline)
                        .foregroundColor(.white)
                        
                        Rectangle()
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 2)
                            .foregroundStyle(.white)
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
                                try await authViewModel.createUser(withEmail: email, password: password, fullName: fullName)
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
                        Text("You have an acccount ")
                            .foregroundStyle(.gray)
                        Text("Login")
                            .foregroundStyle(.black)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                })
            }
            .safeAreaPadding(.all)
            .padding(.horizontal)
            
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
        .ignoresSafeArea(.all)
    }
}


#Preview {
    RegisterView()
}
