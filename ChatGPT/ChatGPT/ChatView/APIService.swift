//
//  APIService.swift
//  ChatGPT
//
//  Created by Mohaymin Islam on 2024-05-22.
//

import Foundation

class OpenAIAPIService {
    private let apiKey = "Open AI API Key"
    private let baseUrl = "https://api.openai.com/v1/chat/completions"

    func sendMessage(_ message: String, model: ChatModel, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: baseUrl) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [
            "model": model == .gpt3_5_turbo ? "gpt-3.5-turbo" : "gpt-4",
            "messages": [
                ["role": "user", "content": message]
            ]
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            completion(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 0, userInfo: nil)))
                return
            }

            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Full JSON Response: \(jsonResponse)")
                    if let choices = jsonResponse["choices"] as? [[String: Any]],
                       let firstChoice = choices.first,
                       let message = firstChoice["message"] as? [String: Any],
                       let responseText = message["content"] as? String {
                        completion(.success(responseText))
                    } else {
                        completion(.failure(NSError(domain: "Invalid Response Format", code: 0, userInfo: nil)))
                    }
                } else {
                    completion(.failure(NSError(domain: "Invalid JSON Structure", code: 0, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
