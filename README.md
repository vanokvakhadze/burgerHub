# 🍔 burgerHub: A Modern Burger App with Secure Features

**burgerHub** is a feature-rich iOS application that provides a delightful experience for browsing and managing your favorite burgers. Designed with a mix of **UIKit** and **SwiftUI**, the app combines performance, functionality, and an engaging user interface.

---

## 🚀 Features

### 🔐 Registration & Login  
- **Custom Authentication**:  
  - Secure registration with password requirements:  
    - Minimum of 8 characters.  
    - At least one uppercase letter.  
    - At least one number and a special character (e.g., `123!`).  
  - Credentials are securely saved in **Keychain**.  
- **Google Authentication**:  
  - Easily sign in using your Google account with **Google Auth Service** integration.  

### 🍔 Home Page  
- Browse a variety of burgers using a visually appealing grid layout.  
- Add burgers to your **Favorites**, which are saved locally using **SwiftData**.  

### 🛒 Shopping Experience  
- **Add to Cart**:  
  - Simulate the shopping experience by adding burgers to your cart.  
  - If a burger is already in the cart, its quantity increases.  
- **Payment Options**:  
  - Add payment methods manually or scan cards directly using **Card Scanning** functionality.  
  - All payment details are securely stored in **Keychain**.  

### 📍 Location Services  
- **MapKit Integration**:  
  - View restaurant locations sorted by distance.  

### 📦 Caching Service  
- Efficient **REST API** integration with caching ensures smooth performance and faster loading times.  

---

## 🛠️ Technologies

### **Development Frameworks**  
- **UIKit**: Used for login and registration pages to leverage precise control over UI.  
- **SwiftUI**: Powers the rest of the application for a modern and reactive user interface.  

### **Data Handling**  
- **Keychain**: Ensures secure storage of sensitive data, such as passwords and card details.  
- **SwiftData**: For saving and managing favorite burgers locally.  
- **Caching Service**: Speeds up data retrieval and reduces API calls.  

### **Third-Party Tools**  
- **Google Auth Service**: Facilitates Google-based login.  

### **MapKit**  
- Provides accurate restaurant location data sorted by proximity.  

---

## 🔧 Setup & Installation

1. Clone the repository:  
   ```bash  
   git clone https://github.com/vanokvakhadze/burgerHub.git  
   cd burgerHub

 2. Install dependencies:
  Add Google Auth Service to your project using Swift Package Manager.
  To install, foll w the instructions in the Google Sign-In for iOS setup guide.
  https://www.youtube.com/watch?v=20Qlho0G3YQ

 
   

