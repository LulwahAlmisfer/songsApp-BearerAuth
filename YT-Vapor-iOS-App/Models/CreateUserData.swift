//
//  CreateUserData.swift
//  YT-Vapor-iOS-App
//
//  Created by lulwah on 08/05/2023.
//

import Foundation
final class CreateUserData: Codable {
  var id: UUID?
  var username: String
  var password: String?

  init(email: String, password: String) {
    self.username = email
    self.password = password
  }
}
