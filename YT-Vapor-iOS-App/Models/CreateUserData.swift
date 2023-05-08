//
//  CreateUserData.swift
//  YT-Vapor-iOS-App
//
//  Created by lulwah on 08/05/2023.
//

import Foundation
final class CreateUserData: Codable {
  var id: UUID?
  var email: String
  var password: String?

  init(email: String, password: String) {
    self.email = email
    self.password = password
  }
}
