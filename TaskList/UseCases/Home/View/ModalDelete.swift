//
//  ModalDelete.swift
//  TaskList
//
//  Created by Nicolas Santiago on 07-02-24.
//

import SwiftUI

struct ModalDelete: View {
    @ObservedObject var viewModel = HomeViewModel()
    @Binding var selectedTask: String
    @Environment(\.presentationMode) var presentationMode
    var onTaskDeleted: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Are you sure you want to delete the task?")
                .font(.subheadline)
                .foregroundStyle(.gray)
            HStack {
                Button(action: {
                    Task {
                        do {
                            try await viewModel.deleteTask(taskID: selectedTask)
                            onTaskDeleted()
                            presentationMode.wrappedValue.dismiss()
                        } catch {
                            print("Error deleting task: \(error.localizedDescription)")
                        }
                    }
                }, label: {
                    Text("Delete")
                        .foregroundStyle(.white)
                })
                .frame(width: 170, height: 50)
                .background(.red)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel")
                        .foregroundStyle(.black)
                })
                .frame(width: 170, height: 50)
                .background(Color(.systemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 15))
            }
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
        .padding(.horizontal, 20)
    }
}

#Preview {
    ModalDelete(selectedTask: .constant(""), onTaskDeleted: {})
}
