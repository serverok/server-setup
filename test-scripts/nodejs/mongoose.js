var mongoose = require('mongoose');

var mongoDB = 'mongodb://127.0.0.1:22666';

const mongoConfig = {
    dbName: "DB_NAME_HERE", // this is the DB
    reconnectInterval: 500,
    reconnectTries: 20,
    useNewUrlParser: true,
    user: "USERNAME", 
    pass: "PASSWORD",
    authSource: "admin" // this is autentication database.
}

mongoose.connect(mongoDB, mongoConfig);
mongoose.Promise = global.Promise;

var db = mongoose.connection;

db.on('error', console.error.bind(console, 'MongoDB connection error:'));

db.on('connected',  function (ref) {
    console.log('connected to mongo server.');
    db.close();
});

