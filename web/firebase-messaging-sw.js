importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyBnarJ5IKAxnObBbA7IcPn1N6KXscWxzUg",
  authDomain: "jambu-100d1.firebaseapp.com",
  projectId: "jambu-100d1",
  storageBucket: "jambu-100d1.appspot.com",
  messagingSenderId: "26836136800",
  appId: "1:26836136800:web:fa71037c38723c5f7aa405",
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});