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
        NavigationView {
            VStack {
                VStack {
                    if let image = profileImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                    }
                    Button(action: {
                        showImagePicker.toggle()
                    }) {
                        Text("Edit Profile Picture")
                            .foregroundColor(.blue)
                            .padding(.top, 10)
                            .font(.subheadline)
                    }
                }
                .padding()

                Form {
                    Section(header: Text("Personal Information")) {
                        TextField("First Name", text: $firstName)
                        TextField("Last Name", text: $lastName)
                        
                        Text(email)
                            .foregroundColor(.gray)

                        NavigationLink(destination: ChangePasswordView(showPasswordChange: $showPasswordChange)) {
                            HStack {
                                Text("Change Password")
                                    .foregroundColor(.white)
                                    .font(.body)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }

                    Section {
                        Button(action: updateProfile) {
                            Text("Update Profile")
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                    }
                    
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
                }
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .navigationTitle("View/Edit Profile")
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
    }

    private func updateProfile() {
        guard let user = Auth.auth().currentUser else { return }

        let database = Firestore.firestore()
        database.collection("users").document(user.uid).setData([
            "firstName" : firstName,
            "lastName" : lastName,
            "email": user.email ?? ""
        ], merge: true) { error in
            if let error = error {
                self.errorMessage = "Error updating profile: \(error.localizedDescription)"
            }
            else {
                print("Profile updated successfully")
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

        print("Uploading image...")

        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                self.errorMessage = "Error uploading image: \(error.localizedDescription)"
                return
            }

            print("Upload successful. Getting download URL...")

            storageRef.downloadURL { url, error in
                if let error = error {
                    self.errorMessage = "Error getting download URL: \(error.localizedDescription)"
                    return
                }

                if let downloadURL = url {
                    print("Got download URL: \(downloadURL)")
                    saveProfileImageURL(downloadURL.absoluteString)
                }
            }
        }
    }

    
    private func saveProfileImageURL(_ url: String) {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).setData([
            "profileImageURL": url
        ], merge: true) { error in
            if let error = error {
                self.errorMessage = "Error saving profile image URL: \(error.localizedDescription)"
            } else {
                print("Profile image URL saved to Firestore.")
            }
        }
    }
    
    private func loadProfileImageFromFirestore() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let docRef = Firestore.firestore().collection("users").document(uid)
        docRef.getDocument { snapshot, error in
            if let error = error {
                print("Error fetching image URL: \(error.localizedDescription)")
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
