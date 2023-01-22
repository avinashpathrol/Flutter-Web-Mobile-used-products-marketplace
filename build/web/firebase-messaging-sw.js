importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js");
const firebaseConfig = {
    apiKey: "AIzaSyB_OL66ttRCjF-3ZgyXt4OhbQ111cig6Z4",
    authDomain: "eagreeinc.firebaseapp.com",
    projectId: "eagreeinc",
    storageBucket: "eagreeinc.appspot.com",
    messagingSenderId: "802493672816",
    appId: "1:802493672816:web:2cd31c09b8600bee7cb3b5",
    measurementId: "G-CNBL381E5X"
  };

  firebase.initializeApp(firebaseConfig);
  const messaging = firebase.messaging();

  /*messaging.onMessage((payload) => {
  console.log('Message received. ', payload);*/
  messaging.onBackgroundMessage(function(payload) {
    console.log('Received background message ', payload);

    const notificationTitle = payload.notification.title;
    const notificationOptions = {
      body: payload.notification.body,
    };

    self.registration.showNotification(notificationTitle,
      notificationOptions);
  });