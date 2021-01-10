const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp(functions.config().functions);

//first fun : when proffessor add course will send notification to all students
exports.CourseTrigger = functions.firestore.document('courses/{courseId}').onCreate
(
    async (snapshot , context)=>
    {
        var payload ={notification: {body: "Proffessor "+snapshot.data().proname + " Add "+snapshot.data().name+" Course", title: 'New Course'}, data: {click_action: 'FLUTTER_NOTIFICATION_CLICK', message: 'message',page:'course'}}
        await admin.messaging().sendToTopic('student',payload);
    }
);

//second fun : when proffessor add new materail to specific course  will send notification to students that register this course
exports.AddMaterailTrigger = functions.firestore.document('materials/{materialId}').onCreate
(
    async (snapshot,context)=>
    {
        var registerstudentemails= [];
        var token = [];
        await admin.firestore().collection('studentcourses').where('progmail','==',snapshot.data().progmail).where('coursename','==',snapshot.data().coursename).get().then((value)=>{
            value.docs.forEach((element)=>{
                registerstudentemails.push(element.data().studentgmail);
            });
        });
        for (let index = 0; index < registerstudentemails.length; index++) {
            await admin.firestore().collection('users').where('usertype','==','Student').where('email','==',registerstudentemails[index]).get().then((value)=>{
                value.docs.forEach((element)=>{
                    token.push(element.data().token);
                });
            });
        }
        var payload ={notification: {body: "Proffessor "+snapshot.data().progmail+" Add New Material", title: "New Material"}, data: {click_action: 'FLUTTER_NOTIFICATION_CLICK', message: 'message',page:'material'}}
        if (registerstudentemails.length ==1) {
            await admin.messaging().sendToDevice(token,payload);
        }
        else{
            await admin.messaging().sendToDeviceGroup(token,payload);
        }
    }
);

// third fun : when student register to course will send notification to proffessor
exports.RegisterCourseTrigger = functions.firestore.document('studentcourses/{studentcourseId}').onCreate
(
    async (snapshot,context)=>
    {
    var token = [];
    await admin.firestore().collection('users').where('email','==',snapshot.data().progmail).get().then((value)=>{
        value.docs.forEach((element)=>{
            token.push(element.data().token);
        });
    });
    var payload ={notification: {body: 'Register to '+snapshot.data().coursename+" Course", title: "Student "+snapshot.data().studentname}, data: {click_action: 'FLUTTER_NOTIFICATION_CLICK', message: 'message',page:'registercourse',name:snapshot.data().coursename}}
        await admin.messaging().sendToDevice(token,payload);
    }
);

