# Talkify

A real-time chat application built using Flutter and various services of Firebase, such as, Firebase Authentication, Cloud Storage, Firestore Database, CLoud Functions, etc. </br>
The application allowed users to authenticate through their email and create a customized account. The app is a typical chat application where users can send messages and images to other registered users.

## Features

- **Real-time Messaging**: Enjoy instant messaging with real-time updates.
- **User Authentication**: Securely authenticate users using Firebase Authentication.
- **Firestore Database Integration**: Store and retrieve chat messages in real-time using Firebase Cloud Firestore.
- **Cloud Storage**: Help to send images via chat and also allow users to customize their profile photo.
- **Flutter UI**: Intuitive and responsive user interface built with Flutter for a smooth user experience.
- **Lexical Seach**: To find specific users amongst all registered users.

## User Flow
![UserFlow](https://github.com/ANSHIKA010/Talkify/assets/99765179/36c3f64c-59c9-4593-bdfd-18784f123b79)

## System Design and Database Schema


## Application Interface (Screen Shots)


## Working Application



# Project Setup
Follow the instruction below to setup the project on your device.

### Prerequisites

Before you begin, ensure you have met the following requirements:

- Flutter installed on your local machine. [Install Flutter](https://flutter.dev/docs/get-started/install)
- Firebase account for setting up Firestore and Authentication. [Firebase Console](https://console.firebase.google.com/)

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/ANSHIKA010/talkify.git
  
2. Move to the created directory.
   ```bash
   cd talkify

3. Install Dependencies
   ```bash
   flutter pub get

4. Setup Firebase
   - Create a new project on the [Firebase Console](https://console.firebase.google.com).
   - Add an Android and/or iOS app to your Firebase project.
   - Download the **google-services.json** (for Android) or **GoogleService-Info.plist** (for iOS) file and place it in the appropriate directory.
  
5. Configure and Deploy Cloud Functions
   - Create a project for google cloud functions.
   - Use the functions designed --> [File containg functions](https://github.com/ANSHIKA010/Talkify_cloud_functions/blob/02c1b2c4d43c236e54f4fba906efb945e7ad6b7e/functions/index.js)
   - Deploy those function on firebase.

6. Run the app
   ```bash
   flutter run


## Contributing

Contributions are welcomed! Please follow the [contribution guidelines]() for details.

# Acknowledgments

![FLutter](https://github.com/ANSHIKA010/Talkify/assets/99765179/74b9c34d-2fc2-4b7d-9ee9-145cd77e0b23) ![Firebase](https://github.com/ANSHIKA010/Talkify/assets/99765179/6b5faedd-7aa6-4a1a-a480-65821a196200)



