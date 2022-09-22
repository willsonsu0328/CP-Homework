//
//  ViewController.swift
//  CPHomePractice
//
//  Created by Wilson on 2022/9/11.
//

import UIKit

class ExampleViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var dataSource: [BaseTableViewItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "GraphQL Example"
        setupTableView()
    }

    func setupTableView() {
        tableView.estimatedRowHeight = 55.0
        tableView.rowHeight = UITableView.automaticDimension

        dataSource = [
            BaseTableViewItem(title: "query users", handler: { [weak self] indexPath in
                self?.queryUsersTapped()
            }),
            BaseTableViewItem(title: "query user with id", handler: { [weak self] indexPath in
                self?.queryUserWithIDTapped()
            }),
            BaseTableViewItem(title: "query todos", handler: { [weak self] indexPath in
                self?.queryTodosTapped()
            }),
            BaseTableViewItem(title: "query userTodos", handler: { [weak self] indexPath in
                self?.queryUserTodosTapped()
            }),
            BaseTableViewItem(title: "mutation updateTodo", handler: { [weak self] indexPath in
                self?.mutationUpdateTodoTapped()
            })
        ]
    }

    func queryUsersTapped() {

        struct users: GQLQueryProtocol {
            var id: String = .defaultValue
            var email: String = .defaultValue
            var name: String = .defaultValue
        }

        APIManager.shared.fetch(query: users()) { (result: Result<ResponseData<UsersData>, Error>) in
            switch result {
            case let .success(responseData):
                print("Response users: \n\n" + "\(responseData.data.users)" + "\n")
            case let .failure(error):
                print(error)
            }
        }

    }

    func queryUserWithIDTapped() {

        struct user: GQLQueryProtocol {
            var id: String = .defaultValue
            var name: String = .defaultValue
            var email: String = .defaultValue
        }

        APIManager.shared.fetch(query: user()) { (result: Result<ResponseData<UserData>, Error>) in
            switch result {
            case let .success(responseData):
                print("Response user: \n\n" + "\(responseData.data.user)" + "\n")
            case let .failure(error):
                print(error)
            }
        }

    }

    func queryTodosTapped() {

        struct todos: GQLQueryProtocol {
            var id: String = .defaultValue
            var description: String = .defaultValue
        }

        APIManager.shared.fetch(query: todos()) { (result: Result<ResponseData<TodosData>, Error>) in
            switch result {
            case let .success(responseData):
                print("Response todos: \n\n" + "\(responseData.data.todos)" + "\n")
            case let .failure(error):
                print(error)
            }
        }

    }

    func queryUserTodosTapped() {

        struct user: GQLQueryProtocol {
            var todos = todo()
        }

        struct todo: GQLQueryProtocol {
            var id: String = .defaultValue
            var description: String = .defaultValue
            var done: Bool = .defaultValue
        }

        APIManager.shared.fetch(query: user(), parameters: [
            "id": "someUser"
        ]) { (result: Result<ResponseData<UserData>, Error>) in
            switch result {
            case let .success(responseData):
                print("Response user's todos: \n\n" + "\(responseData.data.user)" + "\n")
            case let .failure(error):
                print(error)
            }
        }
        
    }

    func mutationUpdateTodoTapped() {

        struct updateTodo: GQLQueryProtocol {
            var id: String = .defaultValue
            var done: Bool = .defaultValue
        }

        let parameters: [String: Any] = [
            "input": [
                "id": "8db57b8f-be09-4e07-a1f6-4fb77d9b16e7",
                "done": true
            ]
        ]

        APIManager.shared.fetch(operationType: .mutation, query: updateTodo(), parameters: parameters) { (result: Result<ResponseData<UpdateTodoData>, Error>) in
            switch result {
            case let .success(responseData):
                print("Response mutation updateTodo: \n\n" + "\(responseData.data.updateTodo)" + "\n")
            case let .failure(error):
                print(error)
            }
        }
        
    }

}

extension ExampleViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: QueryTableViewCell.reuseIdentifier, for: indexPath)
        if let cell = cell as? QueryTableViewCell {
            cell.item = dataSource[indexPath.row]
        }
        return cell
    }
}

extension ExampleViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataSource[indexPath.row]
        if let handler = item.handler {
            handler(indexPath)
        }
    }

}

extension String {
    static let defaultValue = ""
}

extension Bool {
    static let defaultValue = false
}

