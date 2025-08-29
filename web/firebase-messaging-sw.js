importScripts("https://www.gstatic.com/firebasejs/9.0.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.0.0/firebase-messaging-compat.js");

// Инициализируй Firebase (вставь свои конфиги из Firebase console!)
firebase.initializeApp({
    apiKey: "AIzaSyD-KoiYTd4gpG8QJpDYXEnlMpUB-9ScWik",
    authDomain: "appetit-d05d5.firebaseapp.com",
    projectId: "appetit-d05d5",
    storageBucket: "appetit-d05d5.firebasestorage.app",
    messagingSenderId: "9159760125",
    appId: "1:9159760125:web:7362bea70a3d0d08a54694",
    measurementId: "G-RVJVL4TKRX"
});

// Обработчик push сообщений
const messaging = firebase.messaging();