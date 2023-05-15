//
//  LoginView.swift
//  YT-Vapor-iOS-App
//
//  Created by lulwah on 08/05/2023.
//
import SwiftUI

struct LoginView: View {
  @State var username = ""
  @State var password = ""
  @State private var showingLoginErrorAlert = false
  @EnvironmentObject var auth: Auth

  var body: some View {
      NavigationView{
          VStack {
       
          Text("Log In")
            .font(.largeTitle)
          TextField("Username", text: $username)
            .padding()
            .autocapitalization(.none)
            .keyboardType(.emailAddress)
            .border(Color(.black), width: 1)
            .padding(.horizontal)
          SecureField("Password", text: $password)
            .padding()
            .border(Color(.black), width: 1)
            .padding(.horizontal)
          Button("Log In") {
              Task{ try await login() }
          }.disabled(username.isEmpty || password.isEmpty)
              
            NavigationLink(destination: SignUpView().navigationBarBackButtonHidden(true)) {
                Text("Sign uppp").foregroundColor(.red)
            }
            
          
        }
        .alert(isPresented: $showingLoginErrorAlert) {
          Alert(title: Text("Error"), message: Text("Could not log in. Check your credentials and try again"))
    }
      }
  }

    func login() async throws {
        do{
            try await auth.login(username: username, password: password)
        }
        catch {
            throw error
        }
    
  }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
