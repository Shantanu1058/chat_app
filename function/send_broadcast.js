var admin = require("firebase-admin");

var serviceAccount = require("E:/AndroidStudioProjects/chat_app/serverAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});
var db=admin.firestore()
async function start(){
    var tokens=[];
    const collection=db.collection('devices').get();
    (await collection).forEach((doc)=>{
        tokens.push(doc.id);
    })
    var message = {
        notification: {
          title: 'Shantanu',
          body: 'Mirajgave'
        },
      };
      
      admin.messaging().sendToDevice(tokens,message)
        .then((response) => {
          console.log('Successfully sent message:', response);
        })
        .catch((error) => {
          console.log('Error sending message:', error);
        });
}
  start()