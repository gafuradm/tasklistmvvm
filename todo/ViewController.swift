import UIKit
import SnapKit

class ViewController: UIViewController {
    let tableView = UITableView()
    let viewModel = TaskViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavigationBar()
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeGesture.direction = .left
        tableView.addGestureRecognizer(swipeGesture)
    }
    
    func configureNavigationBar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
        navigationItem.title = "Список задач"
    }
    
    @objc func addButtonTapped() {
        let alertController = UIAlertController(title: "Новая задача", message: "Введите название задачи", preferredStyle: .alert)
        alertController.addTextField()
        
        let addAction = UIAlertAction(title: "Добавить", style: .default) { [weak self] _ in
            guard let textField = alertController.textFields?.first else { return }
            let taskName = textField.text ?? ""
            self?.viewModel.createTasks(with: taskName)
            self?.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        if gesture.state == .ended {
            let gestureLocation = gesture.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: gestureLocation) {
                viewModel.deleteTasks(at: indexPath.row)
                tableView.reloadData()
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = viewModel.tasks[indexPath.row]
        cell.textLabel?.text = task.taskName
        if task.completed {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let task = viewModel.tasks[indexPath.row]
        viewModel.tasks[indexPath.row].completed = !task.completed
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
