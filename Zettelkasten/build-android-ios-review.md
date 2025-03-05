# **Android Build & Submission Process**

### **1. Update Environment Variables**

- Modify the necessary environment files (`.env`, `.env.staging`, and `.env.development`) with the provided secrets.
- Verify that the `BASE_URL` is correctly set in **`index.js`** inside the `dist` folder of `color-pencil-binder-tech`.

### **2. Download and Set Up Keystore**

- Retrieve the **keystore** file for the respective app (`whiz`, `pixo`, or `zeta`).
- Place the keystore file inside **`android/app`** directory.

### **3. Update Versioning**

- Update the app version in `android/app/build.gradle`:
    
    ```gradle
    versionCode 10
    versionName "1.0.3"
    ```
    
- Example:
    - Previous version: **1.0.2.9**
    - New version: **1.0.3.10**

### **4. Generate the AAB File**

Run the following command to generate the Android App Bundle (AAB):

```sh
yarn generate-whiz-aab
```

### **5. Upload to Google Play Console**

- Sign in to [Google Play Console](https://play.google.com/console) using the **umm** account.
- Select the appropriate app for release.

### **6. Upload AAB and Provide Release Notes**

- Upload the **AAB file**.
- Enter release notes describing the changes in this version.

### **7. Submit for Review**

- Save the release.
- Click **Submit for Review** to send it for approval.

---

# **iOS Build & Submission Process**

### **1. Update Dependencies**

Navigate to the `ios` folder and run:

```sh
cd ios
pod update
pod install
```

### **2. Update Versioning in Xcode**

- Open the project in **Xcode**.
- Navigate to **General** → **Identity Section**.
- Update **Version** and **Build Number** accordingly.

### **3. Archive the Build**

- In Xcode, select **Product** → **Archive**.

### **4. Distribute the App to App Store Connect**

- Go to **Window** → **Organizer** → **Distribute App**.
- Select **App Store Connect** as the destination.

### **5. Handle Compliance in TestFlight**

- Sign in to [App Store Connect](https://appstoreconnect.apple.com/) using the **umm** account.
- Navigate to **TestFlight** → **Manage Missing Compliance**.
- Select **No algorithms were used** (if applicable).

### **6. Add Test Groups for Testing**

- Add the required groups (e.g., **stakeholders, QA team, etc.**) to TestFlight.

### **7. Submit the Build for Review**

- Go to **App Store Connect** → **My Apps** → **Select App**.
- Navigate to **Distribution** and click the **+** icon on the left.
- Select the latest build from **TestFlight**.
- Add **release notes** describing the changes.

### **8. Save and Submit for Review**

- Click **Save** and **Submit for Review** to send it for approval.

---