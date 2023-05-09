//
//  SignUpView.swift
//  YT-Vapor-iOS-App
//
//  Created by lulwah on 08/05/2023.
//

import SwiftUI

struct SignUpView: View {
  @State var email = ""
  @State var password = ""
  @EnvironmentObject var auth: Auth
    @State private var confirmPassword: String = ""
  @State private var showingUserSaveErrorAlert = false
    @State private var emailErrorAlert = false
    @State private var showingLoginErrorAlert = false
    @State private var passwordErrorAlert = false
    

  var body: some View {

      ZStack {
          Color("AccentColor").ignoresSafeArea()
          RoundedRectangle(cornerRadius: 33, style: .circular)
              .fill(Color("defultColor"))
              .frame(width: UIScreen.screenWidth, height: 696)
              .offset(x: 0, y: 130)
          VStack(spacing: 35){
              Spacer()
              Text("Get Started")
                  .font(.title2)
                  .fontWeight(.bold)
               
             
              TextField("\(Image(systemName: "envelope.fill")) Email Address", text: $email)
                  .frame(width: 323)
                  .padding()
                  .background(Color("textfields"))
                        
              SecureField("\(Image(systemName: "lock.fill")) Password", text: $password)
                  .frame(width: 323)
                  .padding()
                  
     
      
                Button("Sign Up") {
                        Task{
                            try await signUpUser()
                        }
                }
    
       
            }
          .navigationBarTitle("SignUp")
          .navigationBarBackButtonHidden(true)

        .alert(isPresented: $showingUserSaveErrorAlert) {
          Alert(title: Text("Error"), message: Text("There was a problem saving the user"))
        }
        .alert(isPresented: $showingLoginErrorAlert) {
            Alert(title: Text("Error"), message: Text("Could not log in. Check your credentials and try again"))
    }
          
        .alert(isPresented: $emailErrorAlert){
            Alert(title: Text("Error"), message: Text("Please enter a valid email"))
      }
          
        .alert(isPresented: $passwordErrorAlert) {
            Alert(title: Text("Error"), message: Text("Password do not match"))
    }
        .onTapGesture {
            self.endTextEditing()
        }
          
      }
      

  }


    func signUpUser () async throws {
        let newUser = CreateUserData(email: email, password: password)
        
        let url = URL(string:Constants.baseURL + Endpoints.users )
        
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(newUser)
        
        let (_, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw HttpError.badResponse
        }
        auth.login(username: email, password: password){_ in
            
        }
    }
//  func saveUser() {
//
//      let createUser = CreateUserData(businessname: businessname, email: email, password: password)
//      ResourceRequest<User>(resourcePath: "users").saveUser(createUser) { result in
//          switch result {
//          case .success:
//              auth.login(email: email, password: password) {
//                  result in
//                  switch result {
//                  case .success:
//                      break
//                  case .failure:
//                      DispatchQueue.main.async {
//                          self.showingLoginErrorAlert = true
//                      }
//                  }
//              }
//          case .failure:
//              DispatchQueue.main.async {
//                  self.showingUserSaveErrorAlert
//              }
//          }
//      }
//
//
//
//
//  }


}

struct SignUpView_Previews: PreviewProvider {
  static var previews: some View {
      SignUpView()
  }
}


extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}

extension View {
  func endTextEditing() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                    to: nil, from: nil, for: nil)
  }
}
