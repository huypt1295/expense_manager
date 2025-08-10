# Firebase Authentication Setup Guide

## 🔥 Firebase Configuration

### 1. Firebase Console Setup
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: `expensemanager-545c6`
3. Go to Authentication > Sign-in method
4. Enable Google and Facebook providers

### 2. Google Sign-In Setup

#### Android Configuration:
1. In Firebase Console, go to Project Settings > General
2. Add Android app if not already added
3. Download `google-services.json` and replace the existing one
4. Add SHA-1 fingerprint to Firebase project:
   ```bash
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```

#### iOS Configuration:
1. Add iOS app in Firebase Console
2. Download `GoogleService-Info.plist` and replace existing one
3. Add Bundle ID: `com.huypt.expense.expenseManager`

### 3. Facebook Sign-In Setup

#### Facebook Developer Console:
1. Go to [Facebook Developers](https://developers.facebook.com/)
2. Create a new app or use existing one
3. Add Facebook Login product
4. Configure OAuth redirect URIs:
   - Android: `fb{your-app-id}://authorize`
   - iOS: `fb{your-app-id}://authorize`

#### Update Configuration Files:

**Android (`android/app/src/main/res/values/strings.xml`):**
```xml
<string name="facebook_app_id">your_facebook_app_id</string>
<string name="fb_login_protocol_scheme">fbYourAppId</string>
<string name="facebook_client_token">your_facebook_client_token</string>
```

**iOS (`ios/Runner/Info.plist`):**
```xml
<key>FacebookAppID</key>
<string>your_facebook_app_id</string>
<key>FacebookClientToken</key>
<string>your_facebook_client_token</string>
<key>FacebookDisplayName</key>
<string>Expense Manager</string>
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLName</key>
    <string>facebook</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>fbYourAppId</string>
    </array>
  </dict>
</array>
```

### 4. Firebase Console - Authentication Setup

#### Enable Sign-in Methods:
1. Go to Authentication > Sign-in method
2. Enable Google provider:
   - Project support email: your-email@domain.com
   - Web SDK configuration: Use default
3. Enable Facebook provider:
   - App ID: your Facebook app ID
   - App secret: your Facebook app secret

#### Authorized Domains:
Add your domains to authorized domains list for web authentication.

## 🚀 Usage

### Running the App:
1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Generate code:
   ```bash
   flutter packages pub run build_runner build
   ```

3. Run the app:
   ```bash
   flutter run
   ```

### Testing:
- Test Google Sign-In on both Android and iOS
- Test Facebook Sign-In on both platforms
- Verify user data is properly stored in Firebase

## 📝 Notes

- Make sure to replace placeholder values with actual app IDs and tokens
- Test on real devices for social login functionality
- Ensure proper error handling for network issues
- Consider implementing offline authentication state management
