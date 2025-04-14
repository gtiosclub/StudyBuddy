//
//  ViewEditProfile.swift
//  StudyBuddy
//
//  Created by Madhumita Subbiah on 4/9/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct ViewEditProfile: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var profileImage: UIImage? = nil
    @State private var showImagePicker = false
    @State private var errorMessage: String?
    @State private var showPasswordChange: Bool = false

    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            VStack {
                if let image = profileImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white.opacity(0.7))
                }

                Button(action: {
                    showImagePicker.toggle()
                }) {
                    Text("Edit Profile Picture")
                        .foregroundColor(.white)
                        .padding(.top, 10)
                        .font(.subheadline)
                        .underline()
                }
            }
            .padding()

            Form {
                Section(header: Text("Personal Information").foregroundColor(.white)) {
                    EditTextField(placeholder: "First Name", text: $firstName, horizontalPadding: 5)
                    EditTextField(placeholder: "Last Name", text: $lastName, horizontalPadding: 5)
//                    TextField("First Name", text: $firstName)
//                        .foregroundColor(.black)
//                        .padding(8)
//                        .background(Color.white)
//                        .cornerRadius(6)
//
//                    TextField("Last Name", text: $lastName)
//                        .foregroundColor(.black)
//                        .padding(8)
//                        .background(Color.white)
//                        .cornerRadius(6)

                    Text(email)
                        .foregroundColor(.white)

                    NavigationLink(destination: ChangePasswordView(showPasswordChange: $showPasswordChange)) {
                        HStack {
                            Text("Change Password")
                                .foregroundColor(.white)
                            Spacer()
//                            Image(systemName: "chevron.right")
//                                .foregroundColor(.white)
                        }
                    }
                }
                .listRowBackground(Color(hex: "#71569E"))

                Section {
                    Button(action: updateProfile) {
                        Text("Update Profile")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color(hex: "#6213D0"))
                            .cornerRadius(8)
                    }
                }
                .listRowBackground(Color.clear)

                Section {
                    Button(action: {
                        authViewModel.logoutUser()
                    }) {
                        Text("Log Out")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.red)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.red, lineWidth: 1))
                    }
                }
                .listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden) // Remove default form background
            .background(Color(hex: "#321C58"))

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .background(Color(hex: "#321C58").edgesIgnoringSafeArea(.all))
        .navigationTitle("View/Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            userViewModel.fetchUser()
            email = Auth.auth().currentUser?.email ?? ""
            loadProfileImageFromFirestore()
        }
        .onReceive(userViewModel.$user.compactMap { $0 }) { user in
            firstName = user.firstName
            lastName = user.lastName
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $profileImage, allowsEditing: true)
        }
    }

    private func updateProfile() {
        guard let user = Auth.auth().currentUser else { return }

        let db = Firestore.firestore()
        db.collection("Users").document(user.uid).setData([
            "firstName": firstName,
            "lastName": lastName,
            "email": user.email ?? ""
        ], merge: true) { error in
            if let error = error {
                self.errorMessage = "Error updating profile: \(error.localizedDescription)"
            } else {
                presentationMode.wrappedValue.dismiss()
            }
        }

        if let image = profileImage {
            uploadProfileImage(image)
        }
    }

    private func uploadProfileImage(_ image: UIImage) {
        guard let user = Auth.auth().currentUser else {
            self.errorMessage = "User is not authenticated."
            return
        }

        let storageRef = Storage.storage().reference()
            .child("profile_images")
            .child("\(user.uid).jpg")

        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            self.errorMessage = "Error: Unable to process image data."
            return
        }

        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                self.errorMessage = "Error uploading image: \(error.localizedDescription)"
                return
            }

            storageRef.downloadURL { url, error in
                if let error = error {
                    self.errorMessage = "Error getting download URL: \(error.localizedDescription)"
                    return
                }

                if let downloadURL = url {
                    saveProfileImageURL(downloadURL.absoluteString)
                }
            }
        }
    }

    private func saveProfileImageURL(_ url: String) {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        db.collection("Users").document(user.uid).setData([
            "profileImageURL": url
        ], merge: true) { error in
            if let error = error {
                self.errorMessage = "Error saving profile image URL: \(error.localizedDescription)"
            }
        }
    }

    private func loadProfileImageFromFirestore() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let docRef = Firestore.firestore().collection("users").document(uid)
        docRef.getDocument { snapshot, error in
            if let error = error {
                print("Error fetching profile image URL: \(error.localizedDescription)")
                return
            }

            guard let data = snapshot?.data(),
                  let urlString = data["profileImageURL"] as? String,
                  let url = URL(string: urlString) else {
                return
            }

            URLSession.shared.dataTask(with: url) { data, _, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.profileImage = image
                    }
                }
            }.resume()
        }
    }
}
