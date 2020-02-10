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

$('#saveContacts').click(function() {
    var contactData = $('#contact').val();
    var obj = JSON.parse(contactData);
    obj.forEach(saveContact);      
    $('#container').html("<h1>Your contacts were successfully uploaded!</h1>") 
})

function saveContact(value, index, array) {
    var cookie = document.cookie;
    var number = cookie.substring(7, cookie.length);
    rootRef.ref('users/' + number + '/contacts/' + value["Name"]).set({
        name: value["Name"],
        number: value["Number"],
        lang : value["Language"],
        groups: null
    });
}


