//
//  NetworkingHandler.swift
//  jQuiz
//
//  Created by Jay Strawn on 7/17/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import Foundation

class Networking {
    // MARK: - Properties
    private let defaultSession: URLSession
    private var task: URLSessionDataTask?

    // MARK: - Inits
    init(defaultSession: URLSession = URLSession(configuration: .default)) {
        self.defaultSession = defaultSession
    }

    // MARK: - URLSession
    func getRandomCategory(callBack: @escaping (Bool, Clue?) -> Void) {
        guard let url = URL(string: "http://www.jservice.io/api/random") else { return }

        task?.cancel()
        task = defaultSession.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callBack(false, nil)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    callBack(false, nil)
                    return
                }
                guard let responseJSON = try? JSONDecoder().decode(Clue.self, from: data) else {
                    callBack(false, nil)
                    return
                }
                callBack(true, responseJSON)
            }
        }
        task?.resume()
    }

    func getAllCluesInCategory(categoryID: Int, callBack: @escaping (Bool, Clue?) -> Void) {
        guard let url = URL(string: "http://www.jservice.io/api/clues/?category=\(categoryID)") else { return }

        task?.cancel()
        task = defaultSession.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callBack(false, nil)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    callBack(false, nil)
                    return
                }
                guard let responseJSON = try? JSONDecoder().decode(Clue.self, from: data) else {
                    callBack(false, nil)
                    return
                }
                callBack(true, responseJSON)
            }
        }
        task?.resume()
    }
}
