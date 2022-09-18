//
//  ViewController.swift
//  CPHomePractice
//
//  Created by Wilson on 2022/9/11.
//

import UIKit

class ViewController: UIViewController {

    // TODO: struct test, api test

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func queryUsersTapped(_ sender: Any) {

        struct users: GQLQueryProtocol {
            var id: String = ""
            var email: String = ""
            var name: String = ""
        }

        APIManager.shared.queryUsers(query: users()) { response, error, userModels in
            print(userModels ?? "no users data")
        }

    }

    @IBAction func queryUserWithIDTapped(_ sender: Any) {

        struct user: GQLQueryProtocol {
            var id: String = ""
            var name: String = ""
            var email: String = ""
        }

        APIManager.shared.queryUser(query: user(), id: "4dc70521-22bb-4396-b37a-4a927c66d43b") { response, error, userModel in
            print(userModel ?? "no user data")
        }

    }

    @IBAction func queryTodosTapped(_ sender: Any) {

        struct todos: GQLQueryProtocol {
            var id: String = ""
            var description: String = ""
        }

        APIManager.shared.queryTodos(query: todos()) { response, error, todoModels in
            print(todoModels ?? "no todos data")
        }

    }

    @IBAction func queryUserTodosTapped(_ sender: Any) {

        struct user: GQLQueryProtocol {
            var todos = todo()
        }

        struct todo: GQLQueryProtocol {
            var id: String = ""
            var description: String = ""
            var done: Bool = false
        }

        APIManager.shared.queryUser(query: user(), id: "someUser") { response, error, userModel in
            print(userModel ?? "no user todos data")
        }
        
    }


    @IBAction func mutationUpdateTodoTapped(_ sender: Any) {

        struct updateTodo: GQLQueryProtocol {
            var id: String = ""
            var done: Bool = false
        }

        let parameters: [String: Any] = [
            "input": [
                "id": "8db57b8f-be09-4e07-a1f6-4fb77d9b16e7",
                "done": true
            ]
        ]

        APIManager.shared.mutationUpdateTodo(query: updateTodo(), parameters: parameters) { response, error, todoModel in
            print(todoModel ?? "no todoModel data")
        }
        
    }

}

