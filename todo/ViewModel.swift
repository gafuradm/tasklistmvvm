import Foundation
class TaskViewModel {
    var tasks: [Task] = []
    func createTasks(with taskName: String) {
        let newTask = Task(taskName: taskName, completed: false)
        tasks.append(newTask)
    }
    func deleteTasks(at index: Int) {
        tasks.remove(at: index)
    }
}
