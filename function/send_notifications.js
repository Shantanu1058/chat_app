var admin = require("firebase-admin");

var serviceAccount = require("E:/AndroidStudioProjects/chat_app/serverAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

var registrationToken = 'ekqHZuSAQcCOP4DGh1scJj:APA91bGJM_APJEd_Pz49HxqyatyouwZ8fGT7sedN3RL0nGBOm-YDp2wbvk-PWhTzRP4_ZIa-3qqJsl4KxfrJltAAQQr5LzmhjAKZhkrNomUDGvhsxpooyXhcyHX7P2QJxm3QBZQYfcQz';

var message = {
  notification: {
    title: 'Shantanu',
    body: 'Mirajgave'
  },
  token:registrationToken
};

admin.messaging().send(message)
  .then((response) => {
    console.log('Successfully sent message:', response);
  })
  .catch((error) => {
    console.log('Error sending message:', error);
  });