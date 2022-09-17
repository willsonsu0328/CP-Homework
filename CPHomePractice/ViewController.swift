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

        struct Users: GQLQueryProtocol {
            var id: String = ""
            var email: String = ""
            var name: String = ""
        }

        APIManager.shared.queryUsers(query: Users()) { response, error, userModels in
            print(userModels ?? "no users data")
        }

    }

    @IBAction func queryUserWithIDTapped(_ sender: Any) {

        struct User: GQLQueryProtocol {
            var id: String = ""
            var name: String = ""
            var email: String = ""
        }

        APIManager.shared.queryUser(query: User(), id: "4dc70521-22bb-4396-b37a-4a927c66d43b") { response, error, userModel in
            print(userModel ?? "no user data")
        }

    }

    @IBAction func queryTodosTapped(_ sender: Any) {

        struct Todos: GQLQueryProtocol {
            var id: String = ""
            var description: String = ""
        }

        APIManager.shared.queryTodos(query: Todos()) { response, error, todoModels in
            print(todoModels ?? "no todos data")
        }

    }

    @IBAction func queryUserTodosTapped(_ sender: Any) {

        struct User: GQLQueryProtocol {
            var todos = Todo()
        }

        struct Todo: GQLQueryProtocol {
            var id: String = ""
            var description: String = ""
            var done: Bool = false
        }

        APIManager.shared.queryUser(query: User(), id: "someUser") { response, error, userModel in
            print(userModel ?? "no user todos data")
        }
        
    }

}

