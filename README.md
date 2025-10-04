# appwrite_realtime_api_flutter_demo
A minimal implementation of a Flutter app and Dart server function to test the Appwrite Realtime API (watch database events)


/pinger the Flutter app

/ponger the Appwrite server function

Clone this repository.

Edit /pinger/lib/environment.dart with the project info

Edit /ponger/lib/main.dart set the variable APPWRITE_FUNCTION_DATABASE_ID in main.dart or in the function environment after you have create the function on the server

```bash
cd pinger
flutter pub get
flutter run -d chrome --web-port=3000
```
## Server Function ##

Create a new function in your Appwrite project from appwrite.io by pointing your modified clone of this repository

Name: ponger

Runtime: Dart 3.5

Entrypoint: lib/main.dart

Build Settings: dart pub get

Root Directory: ./ponger

Execute Access: whatever you want to test but this app logs in with user/pass so set to Any:read or User:read or UserId:read or label:custom_label etc.

Make sure you have a user meeting those criteria.

After deploy go to Settings and set the Scopes to include Database (it needs read/write access to the row created next). Redeploy the function.

## Database Table ##

Create a database table called 'ping'

Add column 'pingedAt' as DateTime

Create one row.

In Settings set the Permissions to Read for any role you want to test.

Press the FAB + button on the Flutter app. The second press should show the realtime data.
