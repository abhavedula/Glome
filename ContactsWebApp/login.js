var config = {
    apiKey: "AIzaSyC1MzfZDQNfQF3lqZYCt__oTTV77MqOcT0",
    authDomain: "glome-43cc0.firebaseapp.com",
    databaseURL: "https://glome-43cc0.firebaseio.com",
    projectId: "glome-43cc0",
    storageBucket: "glome-43cc0.appspot.com",
    messagingSenderId: "95551013157",
    appId: "1:95551013157:web:314e21e6e42c4aaf9adacc"
  };

firebase.initializeApp(config);

var rootRef = firebase.database();

var accounts = [];

$(document).ready(function() {
    console.log("Account info loaded");
    var query = firebase.database().ref("users");
    query.once("value")
      .then(function(snapshot) {
        snapshot.forEach(function(childSnapshot) {
          var key = childSnapshot.key;
          var childData = childSnapshot.val();

          accounts.push({
            email: childData["email"],
            password: childData["password"],
            number: key,
          });
          
      });
    });
});

$('#loginForm').on('submit', function(e){
    e.preventDefault();
    var email = $('#email').val();
    var password = $("#password").val();
    
    for (var i = 0; i < accounts.length; i++) {
        if (accounts[i]["email"] === email && accounts[i]["password"] === CryptoJS.SHA256(password).toString()) {

            document.cookie = "number=" + accounts[i]["number"];
            window.location.replace("uploadContacts.html");
            localStorage["number"] = accounts[i]["number"];
            return;
        }

    }
    $("#error").html("Incorrect email or password");
    
});

