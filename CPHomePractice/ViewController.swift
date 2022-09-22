//
//  ViewController.swift
//  CPHomePractice
//
//  Created by Wilson on 2022/9/11.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func queryUsersTapped(_ sender: Any) {

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

    @IBAction func queryUserWithIDTapped(_ sender: Any) {

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

    @IBAction func queryTodosTapped(_ sender: Any) {

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

    @IBAction func queryUserTodosTapped(_ sender: Any) {

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


    @IBAction func mutationUpdateTodoTapped(_ sender: Any) {

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

extension String {
    static let defaultValue = ""
}

extension Bool {
    static let defaultValue = false
}


