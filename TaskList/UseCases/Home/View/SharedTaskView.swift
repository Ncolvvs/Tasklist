//
//  SharedTask.swift
//  TaskList
//
//  Created by Nicolas Santiago on 06-02-24.
//

import SwiftUI

struct SharedTaskView: View {
    @ObservedObject var viewModel = HomeViewModel()
    @State private var email: String = ""
    @Environment(\.presentationMode) var presentationMode
    @Binding var sharedTaskIndicator: Bool
    
    var task: Tasks
    
    var body: some View {
        VStack(spacing: 30) {
            Rectangle()
                .frame(width: 40, height: 3)
            
            VStack(spacing: 20) {
                Text("Share your task")
                    .font(.title3)
                    .fontWeight(.black)
                Text("\"\(task.title)\"")
                    .font(.title3)
                    .fontWeight(.black)
                HStack{
                    Text("Enter the email of the user you want to share your task with. Share a task with someone and stay in sinc with your goals everyday")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                    Spacer()
                }
                
                
                TextField("", text: $email, prompt: Text("Enter your contact email")
                    .foregroundColor(.gray.opacity(0.4)))
                .frame(height: 60)
                .font(.headline)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .foregroundColor(.black)
                .padding(.horizontal)
                .textInputAutocapitalization(.never)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.black, lineWidth: 5)
                )
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                
                Button(action: {
                    Task {
                        try await viewModel.findUserIDByEmail(email: email, taskID: task.id)
                        presentationMode.wrappedValue.dismiss()
                        sharedTaskIndicator = true
                    }
                }, label: {
                    Text("Share")
                })
                
                Spacer()
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.all)
    }
}

#Preview {
    SharedTaskView(sharedTaskIndicator: .constant(false), task: Tasks(id: "", title: "", completed: false, user_id: "0"))
}
