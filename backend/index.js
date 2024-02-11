require('dotenv').config();
const express = require('express');
const {Vonage} = require('@vonage/server-sdk');

const app = express();

app.use(express.json());

const port = 3000 || process.env.PORT;

const {API_KEY , API_SECRET} = process.env


const vonage = new Vonage({
    apiKey: API_KEY,
    apiSecret: API_SECRET
})

app.post('/vonage/sms', async (req, res) => {

    const from = "Vonage APIs"
    const to = "917087403779"
    const text = req.body.message;

    await vonage.sms.send({from,to,text})
        .then(resp => { console.log('Message sent successfully'); console.log(resp); })
        .catch(err => { console.log('There was an error sending the messages.'); console.error(err); });

    return res.send({"message":"message sent"});
    
})



app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
})