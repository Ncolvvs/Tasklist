//
//  HomeView.swift
//  TaskList
//
//  Created by Nicolas Santiago on 05-02-24.
//

import SwiftUI



struct HomeView: View {
    @ObservedObject var viewModel = HomeViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var newTaskTitle: String = ""
    @State private var newTaskCompleted: Bool = false
    @State private var keyboardHeight: CGFloat = 0.0
    @State private var availableHeight: CGFloat = 0.0
    @State private var iconsVisible: Bool = false
    @State private var showModal: Bool = false
    @State private var selectedTask: Tasks? = nil
    @State private var tasks: [Tasks] = []
    @State private var isButtonDeleteVisible: [String: Bool] = [:]
    @State private var showModalDelete: Bool = false
    @State private var selectedTaskDelete: String = ""
    @State var sharedTaskIndicator: Bool = false
    
    var body: some View {
            VStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Today")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button(action: {
                         authViewModel.signOut()
                        }, label: {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25)
                                .foregroundStyle(.black)
                        })
                    }
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 15) {
                            ForEach(viewModel.tasks, id: \.id) { task in
                                HStack(spacing: 15) {
                                    HStack {
                                        Button(action: {
                                            Task {
                                                try await viewModel.updateTaskCompleted(taskID: task.id, completed: !task.completed)
                                            }
                                        }, label: {
                                            ZStack {
                                                Rectangle()
                                                    .frame(width: 24, height: 24)
                                                    .foregroundStyle(task.completed ? Color.green : Color(.systemGroupedBackground))
                                                    .foregroundStyle(Color.green)
                                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                                Image(systemName: task.completed ? "checkmark" : "")
                                                    .foregroundStyle(.white)
                                            }
                                        })
                                        
                                        Text(task.title)
                                            .font(.headline)
                                    }
                                    
                                    Spacer()
                                    
                                    if let isVisible = isButtonDeleteVisible[task.id], isVisible == true {
                                        Button(action: {
                                            selectedTaskDelete = task.id
                                            showModalDelete.toggle()
                                        }) {
                                            Image(systemName: "trash")
                                                .foregroundStyle(.red)
                                        }
                                    } else {
                                        Button(action: {
                                            showModal.toggle()
                                            selectedTask = task
                                        }, label: {
                                            Image(systemName: sharedTaskIndicator ? "person.2" : "square.and.arrow.up")
                                                .foregroundStyle(.black)
                                        })
                                    }
                                }
                                .padding()
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                                .onTapGesture {
                                    // Muestra u oculta el botón de eliminación cuando se toca la tarea
                                    if let isVisible = isButtonDeleteVisible[task.id] {
                                        isButtonDeleteVisible[task.id] = !isVisible
                                    } else {
                                        isButtonDeleteVisible[task.id] = true
                                    }
                                }
                            }
                        }
                    }
                }
                
                Spacer()
                
                VStack {
                    HStack(spacing: 20) {
                        ForEach(viewModel.sotredIcon, id: \.id) { ic in
                            Button(action: {
                                newTaskTitle += "\(ic.icon) "
                            }, label: {
                                Text(ic.icon)
                                    .font(.title)
                            })
                        }
                    }
                    .opacity(iconsVisible ? 1 : 0)
                    
                    HStack {
                        TextField("", text: $newTaskTitle, prompt: Text("Write a new task")
                            .foregroundColor(.gray.opacity(0.4)))
                        .frame(height: 45)
                        .font(.headline)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .foregroundColor(.black)
                        .padding(.horizontal)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        
                        Button(action: {
                            print("New task title: \(newTaskTitle)")
                            Task {
                                try await viewModel.createTask(title: newTaskTitle, completed: newTaskCompleted, user_id: viewModel.fetchUserId() ?? "")
                                newTaskTitle = ""
                                iconsVisible = false
                            }
                            
                        }, label: {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 45)
                                .foregroundColor(formIsValid ? Color.green : Color.gray)
                        })
                    }
                }
                .padding(.bottom, 5)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal)
            .background(Color(.systemGroupedBackground))
            // MARK: Setting for when the keypad is opened
            .offset(y: -max(0, keyboardHeight - availableHeight))
            .animation(.spring())
            .onAppear {
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (notification) in
                    guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                        return
                    }
                    
                    self.keyboardHeight = keyboardFrame.height
                    self.availableHeight = UIScreen.main.bounds.height - keyboardFrame.height
                    self.iconsVisible = true
                }
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (notification) in
                    self.keyboardHeight = 0
                    self.availableHeight = 0
                    self.iconsVisible = false
                }
            }
            .sheet(isPresented: $showModal, content: {
                SharedTaskView(sharedTaskIndicator: $sharedTaskIndicator, task: selectedTask ?? Tasks(id: "", title: "", completed: false, user_id: ""))
                    .presentationDetents([.height(500)])
            })
            .sheet(isPresented: $showModalDelete, content: {
                ModalDelete(selectedTask: $selectedTaskDelete, onTaskDeleted: {
                    // MARK: Refreshes the task list after deleting a task
                    Task {
                        await viewModel.fetchTasksForCurrentUser()
                    }
                })
                    .presentationDetents([.height(150)])
            })
    }
}



extension HomeView: TextFieldFormProtocol {
    var formIsValid: Bool {
        return !newTaskTitle.isEmpty
    }
}

#Preview {
    HomeView()
}
