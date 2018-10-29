import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp()

exports.sendNotifications = functions.firestore.document('/Notifications/{notificationId}').onWrite((change, context) => {
    // Only send a notification when a message has been created.

    // Notification details.
    const original = change.after.data();

    const token = original.to_token; 

    const payload = {
        notification: {
            title: `${original.sender}: ${original.title}`,
            body: `${original.message}`,
            led: 'red'
      }
    };

    return admin.messaging().sendToDevice(token, payload);
});
