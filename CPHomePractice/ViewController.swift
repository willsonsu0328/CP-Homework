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

        APIManager.shared.fetch2(query: users()) { (result: Result<ResponseData<UsersData>, Error>) in
            switch result {
            case let .success(responseData):
                print(responseData.data.users)
            case let .failure(error):
                print(error)
            }
        }

    }

    @IBAction func queryUserWithIDTapped(_ sender: Any) {

        struct user: GQLQueryProtocol {
            var id: String = ""
            var name: String = ""
            var email: String = ""
        }

        APIManager.shared.fetch2(query: user()) { (result: Result<ResponseData<UserData>, Error>) in
            switch result {
            case let .success(responseData):
                print(responseData.data.user)
            case let .failure(error):
                print(error)
            }
        }

    }

    @IBAction func queryTodosTapped(_ sender: Any) {

        struct todos: GQLQueryProtocol {
            var id: String = ""
            var description: String = ""
        }

        APIManager.shared.fetch2(query: todos()) { (result: Result<ResponseData<TodosData>, Error>) in
            switch result {
            case let .success(responseData):
                print(responseData.data.todos)
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
            var id: String = ""
            var description: String = ""
            var done: Bool = false
        }

        APIManager.shared.fetch2(query: user(), parameters: [
            "id": "someUser"
        ]) { (result: Result<ResponseData<UserData>, Error>) in
            switch result {
            case let .success(responseData):
                print(responseData.data.user)
            case let .failure(error):
                print(error)
            }
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

        APIManager.shared.fetch2(operationType: .mutation, query: updateTodo(), parameters: parameters) { (result: Result<ResponseData<UpdateTodoData>, Error>) in
            switch result {
            case let .success(responseData):
                print(responseData.data.updateTodo)
            case let .failure(error):
                print(error)
            }
        }
        
    }

}

