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

## System Design

### 1. System Architecture
The system consists of the following major components:

- Client Application: Built with Flutter, the client app handles the user interface and interactions, including sending and receiving messages and images.
- Firebase Authentication: Manages user authentication and secure login using email and password.
- Firestore Database: A NoSQL database that stores user profiles, messages, and other chat-related data in real-time.
- Firebase Cloud Storage: Stores media files such as profile pictures and images shared in chat.
- Cloud Functions: Used for server-side logic, such as sending notifications, handling complex queries, and other backend operations.

### 2. Component Interaction

- User Authentication: Users register or log in using their email credentials. Firebase Authentication manages secure sessions.
- Real-time Messaging: Messages are sent and received in real-time using Firestore, where each conversation is stored as a collection of messages.
- Media Sharing: Images sent in chat are uploaded to Firebase Cloud Storage, and their URLs are stored in Firestore.
- Profile Management: Users can update their profiles, including their profile pictures, which are stored in Cloud Storage.

### 3. Data Flow

- Auth Section:
  - User opens the app -> Check if the user is logged in.
  - If not logged in -> Redirect to Login or Registration page.
  - Upon successful login -> Redirect to the Dashboard.
- On Dashboard:
  - Access Conversations, Users, or Profile sections.
  - Start a new conversation or continue an existing one.
- Messaging:
  - Send text messages or images.
  - Messages are displayed in real-time.

## Database Schema
### 1. Users Collection
```
Document ID: UserID (auto-generated)
Fields:
email: String - User's email address.
username: String - User's display name.
profileImageUrl: String - URL of the profile picture stored in Cloud Storage.
status: String - User status (online, offline).
createdAt: Timestamp - Account creation date.
lastLogin: Timestamp - Last login date.
```
### 2. Conversations Collection
```
Document ID: ConversationID (auto-generated)
Fields:
participants: Array - List of user IDs participating in the conversation.
lastMessage: String - Preview of the last message sent.
lastMessageTimestamp: Timestamp - Time when the last message was sent.
```
### 3. Messages Subcollection (under Conversations)
```
Document ID: MessageID (auto-generated)
Fields:
senderId: String - User ID of the sender.
text: String - Content of the text message (if any).
imageUrl: String - URL of the image in Cloud Storage (if any).
timestamp: Timestamp - Time when the message was sent.
```
### 4. Images Collection (optional, if storing separately)
```
Document ID: ImageID (auto-generated)
Fields:
uploadedBy: String - User ID who uploaded the image.
imageUrl: String - URL of the image in Cloud Storage.
uploadedAt: Timestamp - Time when the image was uploaded.
```
## Application Interface (Screen Shots)

<span><img src="https://github.com/user-attachments/assets/f758ed77-eae8-40dd-b34c-525457c56798" width="30%"/></span>
<span><img src="https://github.com/user-attachments/assets/53fd2f87-9e6a-48dd-843e-7356da220616" width="30%"/></span>
<span><img src="https://github.com/user-attachments/assets/b334a5ea-5804-43cc-9537-bcdd33c0e481" width="30%"/></span>
<span><img src="https://github.com/user-attachments/assets/e1fbd729-1d75-4f52-9e38-3a090de51d6a" width="30%"/></span>
<span><img src="https://github.com/user-attachments/assets/989a0103-a454-4f93-aa97-f0db076a7eef" width="30%"/></span>
<span><img src="https://github.com/user-attachments/assets/b358e2b3-ade6-40ad-af07-35f584b42f4e" width="30%"/></span>

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
   - Configure your project using [flutterfire](https://firebase.google.com/docs/flutter/setup?platform=android)
  
5. Configure and Deploy Cloud Functions
   - Activate the service in firebase project for google cloud functions.
   - Use the functions designed --> [File containg functions](https://github.com/ANSHIKA010/Talkify_cloud_functions/blob/02c1b2c4d43c236e54f4fba906efb945e7ad6b7e/functions/index.js)
   - Deploy those function on firebase.

6. Run the app
   ```bash
   flutter run
  

## Contributing

Contributions are welcomed! Please follow the [contribution guidelines]() for details.

# Acknowledgments

![FLutter](https://github.com/ANSHIKA010/Talkify/assets/99765179/74b9c34d-2fc2-4b7d-9ee9-145cd77e0b23) ![Firebase](https://github.com/ANSHIKA010/Talkify/assets/99765179/6b5faedd-7aa6-4a1a-a480-65821a196200)



