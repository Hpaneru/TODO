import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';



admin.initializeApp({
    serviceAccountId:
        "firebase-adminsdk-zahde@todo-2bf04.iam.gserviceaccount.com",
    credential: admin.credential.cert({
        clientEmail: "firebase-adminsdk-zahde@todo-2bf04.iam.gserviceaccount.com",
        privateKey:
            "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDZwytV1vyQJcZL\nwiV1WBLz4gwYINZqCmev4Km3LRfKeUA3qn+xviFdcHirSTTUe9iyxP609dfkRFjd\nS65xFAwd+xpx5b8IxmZ8qQr+h8zaakRXRBTv3y3KLmaOI65Birp4cifHH5x8JV/j\n4miyECLaLrHkhHyaJmwttIa0eVh1lM8Z4wYREZqAcT7102EudAIHknmwZ24RPfc9\nMy6OuKeW8FOqLGOZEqNbq1gNRiWi7OaV8AwDQp1dFzGroqjBqkz80J2MpZCur4C3\nV1oWmiu6vkkJrljxc+G94IeI00NoDyhWlr7SijopttGMZJcmN0cPoV1dhpoMJKs7\nc91kWsw/AgMBAAECggEAJJ5FsMMcqG65uC6XFvLvCPTXnM0U0TMbuX8ZevSJviIC\nkvnITE7RFIHfwMnoKN0ElRc8T5jRq5B0sw3RcTFyUi5SBZohNCwMuuTANQoIACiD\ngnsv3CBW9ls0Iq3MVTgrYCquFrVxnoy4Yb1GZr8A5ViZ0HgY7eENKuhjCIEpR2gl\nvFUhxoZAb5R6IcE11KLewQS4RTR2OUIrFzJL4oUHa+ZeHDGC/8gT2Bbv0cE/qF2O\nDzxymYvQpAUvHDZSeujx6MnoX8NnIg7CPTtXgbVsCcD6erwq4ZbB7WHE0OxN6LQO\nt59vK/pjso1YldPk5Q/HNB6StViLD7jlUPCDH9qlRQKBgQDt7rrxajVZj31p8i0F\nqjz7vaKVSCmgX5p0z4W6KGND2XO1bL2DbFTFt54S901ofV7T/JIrXbE0bxfNZifO\nE1nQxoqu85tb6iXYXKExKwdtEAkhErF2qaLKK+q9coM9Nk/nbQYcHtQ41BOdamPq\n2zu6Gk3/bkH3JMmQGprcu72BBQKBgQDqTFfHoYdQ8Efk/aAeT3q9rRqpmocbCvVZ\nrO8Wau9bDdSoTvro7OrA9dAb31KjiJmwacIADZdmE4diqMyGQn8oR1PsibyiQrX+\n6E4BUBaxoYsSEOuKWeXM/SLcjNONnDJebss8kG+F5Qgk2v2f8o5F78pmCC/8zp4W\nT+EwgLYrcwKBgHcCDadqxDyDtOslIrfOqqoP9B5O9eMtbog2tGCkiuIJBgMc3L27\nlbs/WGWMJL+61Y+aqVHfjx724iTuj8JXk3kFlaBkYLTcrQlHa6i4KQK4HpjYTMNZ\nnf8ZcFRJzrLzU4wh0AiIswWprhXyfP+foIQ5XAIDGCOR1u+pHwSBMwwxAoGAGyJ4\nUBBvAXqyeNy+vIPr7SetHNNerk0YmSgkEG6WBe+WH1/2Qx+dGHffgDre8T2SvxGg\nfC0WyaWdWlm+RhZRb7LDD3PsOsaLGViCIDjMSAozdwYqoT1EFfeDIBPXNGFQnAss\n0njP0avyw4HxOaL3wzXANQzhsd+kA2WA6QMfFe0CgYB7zIHvumCaAeaVCG7Ht2m5\n9YzkW+vxWeqaVt9EPeESyL2UXOMPiul0sKeYoSkrgQuGXO2s/hWw2Fi+nSgALNNg\n4xr+ELbkPy5350u/AUBMX5Eij8NP721gWMgPMJQFozibThPbnMYQCL/h8bgWbsk0\ntJfxfBYDCQkt5Bb0KbYZOQ==\n-----END PRIVATE KEY-----\n",

        projectId: "todo-2bf04"
    }), 
    databaseURL: "https://todo-2bf04.firebaseio.com",
    projectId: "todo-2bf04"
});

export const onDemoCreated = functions.firestore.document("/demo/{id}").onCreate(async (data, context) => {
    const fetchedData = data.data();
    await admin.firestore().collection("demo").doc(fetchedData?.id).update({
        "isSubcollectionDeleted": false,
    });
});


export const onDemoUpdated = functions.firestore.document("/demo/{id}").onUpdate(async (data, context) => {
    const beforeData = data.before.data();
    await admin.firestore().collection("demo").doc(beforeData?.id).update({
        "isUpdated": true,
    });
});

// export const onDeleting = functions.firestore.document("/demo/{id}/subCollection/{id}").onDelete(async (snapshot, context) => {
//     const data = snapshot.data();
//     await admin.firestore().collection('History').doc(context.params.uid).collection("demo").doc(context.params.id).set({data});

// })

export const onWriting = functions.firestore.document("/demo/{id}").onWrite(async (data, context) => {
    const beforeData = data.before.data();
    await admin.firestore().collection("demo").doc(beforeData?.id).update({
        "writtenAt": new Date().getTime(),
    });
});

export default {
onRequestExample: functions.https.onRequest(async (req: any, res : any)=>{
    if (req.method !== "POST") {
        res.append("Invalid Request");
        res.sendStatus(400);
    }
    console.log("Hello Guys Whats Up!!!");
    console.log("This is the example of http onRequest"); 
    res.send("OK");
}),

onCallExample: functions.https.onCall(async(data, context)=> {
  console.log("THIS  IS THE EXAMPLE OF ON CALL"); 
}),
};

