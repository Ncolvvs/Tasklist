    //
    //  HomeVIewModel.swift
    //  TaskList
    //
    //  Created by Nicolas Santiago on 05-02-24.
    //

    import Foundation
    import Combine
    import Firebase
    import FirebaseFirestoreSwift

    protocol TextFieldFormProtocol {
        var formIsValid: Bool { get }
    }

    class HomeViewModel: ObservableObject {
        @Published var tasks: [Tasks] = []
        @Published var shared_task: [SharedTask] = []
 
        @Published var sotredIcon: [Icon] = [
            Icon(icon: "🚀"),
            Icon(icon: "✅"),
            Icon(icon: "🛒"),
            Icon(icon: "🎉"),
            Icon(icon: "🏃"),
            Icon(icon: "🎂"),
            Icon(icon: "🎁")
        ]
        
        init() {
            Task {
                await fetchTasksForCurrentUser()
            }
        }
        
        func createTask(title: String, completed: Bool, user_id: String) async throws {
            do {
                // MARK: Create a reference to the document in Firestore using the user ID
                let documentReference = Firestore.firestore().collection("tasks").document()
                
                // MARK: Create the Task object with the provided data
                let task = Tasks(id: documentReference.documentID, title: title, completed: completed, user_id: user_id)
                
                // MARK: Convert the Task object to a dictionary in order to save it in Firestore
                let data = try await Firestore.Encoder().encode(task)
                
                // MARK: Attempting to save data in Firestore
                try await documentReference.setData(data)
                
                // MARK: Refreshing the task list after creating a new task
                await fetchTasksForCurrentUser()
            } catch {
                // MARK: Handling any errors that occur during the process
                print("DEBUG: Failed to create task with error \(error.localizedDescription)")
            }
        }
        
        func deleteTask(taskID: String) async throws {
            do {
                // MARK: Get the reference to the document of the task you want to delete
                let taskReference = Firestore.firestore().collection("tasks").document(taskID)
                
                // MARK: Try to delete the document task in Firestore
                try await taskReference.delete()
                
                // MARK: Refresh task list after task deletion
                await fetchTasksForCurrentUser()
            } catch {
                // MARK: Handling any errors that occur during the process
                print("DEBUG: Error deleting task: \(error.localizedDescription)")
            }
        }
        
        func updateTaskCompleted(taskID: String, completed: Bool) async throws {
            do {
                // MARK: Get the reference to the document you want to update
                let taskReference = Firestore.firestore().collection("tasks").document(taskID)
                
                // MARK: Creates a dictionary with the field 'completed' and its new value
                let newData = ["completed" : completed]
                
                // MARK: Try to update the 'completed' field of the document in Firestore
                try await taskReference.updateData(newData)
                
                // MARK: Refreshes the task list after update
                await fetchTasksForCurrentUser()
            } catch {
                // MARK: Handling any errors that occur during the process
                print("DEBUG: Error updating task completion: \(error.localizedDescription)")
            }
        }
        
        func sharedTask(taskID: String, user_id: String) async throws {
            do {
                // MARK: Create a reference to the document in Firestore using the user ID
                let documentReference = Firestore.firestore().collection("shared_task").document()
                
                // MARK: Create the SharedTask object with the provided data
                let shared_task = SharedTask(id: documentReference.documentID, task_id: taskID, user_id: user_id)
                
                // MARK: Convert the Task object to a dictionary in order to save it in Firestore
                let data = try await Firestore.Encoder().encode(shared_task)
                
                // MARK: Attempting to save data in Firestore
                try await documentReference.setData(data)
                
                // MARK: Update the task list after sharing a new task
                await fetchTasksForCurrentUser()
            } catch {
                // MARK: Handling any errors that occur during the process
                print("DEBUG: Failed to create shared task with error \(error.localizedDescription)")
            }
        }
        
        func findUserIDByEmail(email: String, taskID: String) async throws -> String? {
            do {
                // MARK: Performs a query in the user collection
                let querySnapshot = try await Firestore.firestore()
                    .collection("users")
                    .whereField("email", isEqualTo: email)
                    .getDocuments()
                
                // MARK: Check if documents were found
                if let document = querySnapshot.documents.first {
                    // MARK: Extracts the user's document ID
                    try await sharedTask(taskID: taskID, user_id: document.documentID)
                    return document.documentID
                } else {
                    // MARK: No user was found with the email address provided.
                    return nil
                }
            } catch {
                // MARK: Handling any errors that occur during the process
                print("DEBUG: Error finding user ID by email: \(error.localizedDescription)")
                return nil
            }
        }
                
        func fetchTasksForCurrentUser() async {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            do {
                // MARK: Fetch Individual Tasks
                let querySnapshotTask = try await Firestore.firestore()
                    .collection("tasks")
                    .whereField("user_id", isEqualTo: uid)
                    .getDocuments()
                
                let tasks = querySnapshotTask.documents.compactMap { document -> Tasks? in
                    let data = document.data()
                    guard let title = data["title"] as? String,
                          let completed = data["completed"] as? Bool,
                          let user_id = data["user_id"] as? String else {
                        return nil
                    }
                    
                    let id = document.documentID
                    return Tasks(id: id, title: title, completed: completed, user_id: user_id)
                }
                
                // MARK: Fetch Shared Tasks
                let querySnapshotShared = try await Firestore.firestore()
                    .collection("shared_task")
                    .whereField("user_id", isEqualTo: uid)
                    .getDocuments()
                
                let sharedTasks = querySnapshotShared.documents.compactMap { document -> SharedTask? in
                    let data = document.data()
                    guard let task_id = data["task_id"] as? String,
                          let user_id = data["user_id"] as? String else {
                        return nil
                    }
                    
                    let id = document.documentID
                    return SharedTask(id: id, task_id: task_id, user_id: user_id)
                }
                
                // MARK: Fetch additional information of the shared tasks
                let fetchSharedTaskInfo: (SharedTask) async -> Tasks? = { sharedTask in
                    let sharedTaskDocument = try? await Firestore.firestore()
                        .collection("tasks")
                        .document(sharedTask.task_id)
                        .getDocument()
                    
                    if let sharedTaskData = sharedTaskDocument?.data(),
                       let title = sharedTaskData["title"] as? String,
                       let completed = sharedTaskData["completed"] as? Bool,
                       let user_id = sharedTaskData["user_id"] as? String {
                        return Tasks(id: sharedTask.task_id, title: title, completed: completed, user_id: user_id)
                    } else {
                        return nil
                    }
                }
                
                // MARK: Combine Individual and Shared Tasks
                var allTasks = tasks
                await withTaskGroup(of: Tasks?.self) { taskGroup in
                    for sharedTask in sharedTasks {
                        taskGroup.addTask {
                            await fetchSharedTaskInfo(sharedTask)
                        }
                    }
                    for await task in taskGroup {
                        if let task = task {
                            // MARK: If the task is not nil, add it to the combined list
                            allTasks.append(task)
                        }
                    }
                }
                
                // MARK: Update the published property with the combined tasks
                DispatchQueue.main.async {
                    self.tasks = allTasks
                }
            } catch {
                // MARK: Handling any errors that occur during the process
                print("DEBUG: Error fetching tasks for current user: \(error.localizedDescription)")
            }
        }

        // MARK: Get user id
        func fetchUserId() -> String? {
            return Auth.auth().currentUser?.uid
        }
    }
