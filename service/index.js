const mysql = require('mysql');
const express = require('express');
const { dbconfig } = require('./dbconfig');
const e = require('express');

const dbConn = mysql.createConnection(
    dbconfig
);

//dbConn.connect();

const app = express();
app.use(express.json({ extended: false }));

// configuration =========================
app.set('port', process.env.PORT || 3000);

app.get('/', (req, res) => {
    res.send('Root');
});

app.get('/users/all', (req, res) => {
    dbConn.query('SELECT * from user_table', (error, rows) => {
        if (error) throw error;
        console.log('User info is: ', rows);
        res.send(rows);
    });
});

app.post('/users/signup', (req, res) => {
    //console.log(req.query);
    const { user_id, user_name, user_email, user_password } = req.body;
    console.log(user_id, user_name, user_email, user_password);
    let params = [user_id, user_name, user_email, user_password];
    let query = "INSERT INTO USER_TABLE VALUES (?,?,?,md5(?))";
    dbConn.query(query, params, (error, rows) => {
        console.log('rows:', rows, rows.length);
        if (error) {
            console.log(error);
            res.json({ success: false });
            throw error;
        } else {

            res.json({ success: true });
        }
    });
});

app.post('/users/valid_email', (req, res) => {
    //console.log(req.query);
    const { user_email } = req.body;

    console.log('req.query========>', req.query);
    console.log('req.body========>', req.body);
    console.log('req.params========>', req.params);
    let query = "select user_email from user_table where user_email= ?";
    dbConn.query(query, user_email, (error, rows) => {
        console.log('rows:', rows);
        if (error) {
            console.log(error);
            res.json({ error: error });
        } else {
            if (rows.length == 1) {
                res.json({ isExistEmail: true });
            } else {
                res.json({ isExistEmail: false });
            }
        }
    });
});


app.post('/users/login', (req, res) => {
    //console.log(req.query);
    const { user_email, user_password } = req.body;

    //console.log('req.query========>', req.query);
    console.log('req.body========>', req.body);
    //console.log('req.params========>', req.params);
    let query = "select count(*) cnt from user_table where user_email= ? and user_password = md5(?)";
    dbConn.query(query, [user_email, user_password], (error, rows) => {
        console.log('rows:', rows);
        if (error) {
            console.log(error);
            res.json({ error: error });
        } else {
            if (rows[0].cnt == 1) {
                res.json({ isExistUser: true });
            } else {
                res.json({ isExistUser: false });
            }
        }
    });
});

app.listen(app.get('port'), () => {
    console.log('Express server listening on port ' + app.get('port'));
});

//dbConn.end();