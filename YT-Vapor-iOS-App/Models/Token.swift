//
//  Token.swift
//  YT-Vapor-iOS-App
//
//  Created by lulwah on 08/05/2023.
//

import Foundation

final class Token: Codable {
  var id: UUID?
  var value: String

  init(value: String) {
    self.value = value
  }
}
