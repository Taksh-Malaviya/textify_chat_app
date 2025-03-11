# Textify App

**Textify** is a real-time chat application that allows users to send and receive messages instantly, utilizing Firebase for both Authentication and Firestore Database to store and sync messages. It's designed to be simple yet effective for building a modern chat application. With a sleek user interface and real-time updates, **Textify** can be a foundation for building more advanced chat applications.

---

## Table of Contents

- [Features](#features)
- [Technologies Used](#technologies-used)
- [Installation](#installation)
  - [Clone the repository](#clone-the-repository)
  - [Install Dependencies](#install-dependencies)
  - [Set up Firebase](#set-up-firebase)
  - [Configure Firebase in Your Project](#configure-firebase-in-your-project)
  - [Run the Application](#run-the-application)
- [App Overview](#app-overview)
  - [Authentication](#authentication)
  - [Real-Time Messaging](#real-time-messaging)
  - [User Profiles](#user-profiles)
- [Features to Implement](#features-to-implement)
- [Contributing](#contributing)
- [License](#license)

---

## Features

**Textify** offers the following features:

- **Real-time Messaging:** 
  Users can send and receive messages instantly. Once a message is sent, all connected clients are updated in real-time without needing to refresh the page.
  
- **User Authentication:**
  The app allows users to sign up, log in, and manage their sessions using Firebase Authentication (supports Email/Password, Google, and other authentication methods).
  
- **Firestore Database Integration:**
  Messages are stored in Firestore, Firebase's real-time NoSQL database, which allows instant message synchronization across devices.
  
- **User Profiles:**
  Users can create profiles with basic information (such as their name and avatar), and this data is saved and can be updated anytime.
  
- **Mobile-Friendly UI:**
  The app is fully responsive and is optimized for both desktop and mobile devices. It uses React to build a smooth and seamless interface.

- **Push Notifications** (Future Implementation):
  Future versions will implement push notifications, so users will be notified when they receive new messages, even when they aren't actively using the app.

---

## Technologies Used

This project uses the following technologies:

- **Firebase:**
  - Firebase Authentication for user login and registration.
  - Firestore Database for storing and syncing messages.
  
- **React:** 
  - React is used for building the user interface. It provides a dynamic and interactive experience by re-rendering components when the state changes.
  
- **React Router:** 
  - React Router is used for navigating between different views, like login, chat, and user profile pages.

- **CSS:** 
  - Custom styles are used for making the app visually appealing and responsive across devices.

- **React Firebase Hooks:**
  - Helps interact with Firebase more easily and efficiently by providing hooks to work with Firebase Authentication and Firestore.

- **Node.js (Optional):**
  - Node.js can be used to build any additional backend APIs if necessary, though the current version of Textify is client-side only.

---

## Images
<img src="https://github.com/user-attachments/assets/5be11646-1818-4334-ad5d-3aabbbe79517" width=250px>
<img src="https://github.com/user-attachments/assets/ea09908f-b606-4787-83d1-bbdb769f15f8" width=250px>
<img src="https://github.com/user-attachments/assets/7b231f96-ffcc-4a0b-9727-417ce1c260fa" width=250px>
<img src="https://github.com/user-attachments/assets/05d8c550-55b6-421c-a4b3-6d89846d6b52" width=250px>
<img src="https://github.com/user-attachments/assets/2738591a-fb3c-4224-b4ae-ddcaa01b7404" width=250px>
<img src="https://github.com/user-attachments/assets/5aa4c5d6-d7a1-4b82-8413-847a46180151" width=250px>
<img src="https://github.com/user-attachments/assets/8e4a9400-2e94-41d9-941d-93ad593fb8a0" width=250px>
<img src="https://github.com/user-attachments/assets/9fd99a6c-af32-435f-b12b-e9b61b03e815" width=250px>




## Installation

### Clone the repository

Start by cloning the repository to your local machine. Open your terminal and run:

```bash
git clone https://github.com/yourusername/textify-app.git




