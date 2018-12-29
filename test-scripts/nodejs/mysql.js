//////My sql

const mysql = require('mysql');

const connection = mysql.createConnection({
  host: 'localhost',
  user: 'DB_USER_HERE',
  password: 'PASSWORD_HERE',
  database: 'DB_NAME_HERE',
  insecureAuth : true,
  socketPath: '/var/run/mysqld/mysqld.sock'
});

connection.connect((err) => {
  if (err) throw err;
  console.log('Connected!');
});
