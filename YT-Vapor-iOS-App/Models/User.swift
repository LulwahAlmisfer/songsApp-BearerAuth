//
//  User.swift
//  YT-Vapor-iOS-App
//
//  Created by lulwah on 08/05/2023.
//ارجعي له مهم 

import Foundation

final class User: Codable, Identifiable {
  var id: UUID?
  var name: String
  var username: String

  init(id: UUID? = nil, name: String, username: String) {
    self.id = id
    self.name = name
    self.username = username
  }
}
