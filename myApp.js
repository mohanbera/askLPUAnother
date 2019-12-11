const axios = require('axios');
const express = require('express');
var cors = require('cors');
const router = express.Router();
const randomString = require('randomstring');
const fs = require('fs');
const path = require('path');
const buffer = require('buffer');
const port = "7000"

const firstUMS = "https://ums.lpu.in//umswebservice/umswebservice.svc/CheckVersion/b5d2f187616d3553";
const secondUMS = "https://ums.lpu.in/umswebservice/umswebservice.svc/Testing";
const thirdUMS = "https://ums.lpu.in/umswebservice/umswebservice.svc/StudentBasicInfoForService/";
const app = express();
app.use(cors());

const bool=true;

app.get('/', (req, res) => {
    
    var regId = req.query.regId;
    var password = req.query.password;

    console.log(regId+" "+password);

    if(regId && password)
    {
    	axios.get(firstUMS)
            .then((response) => {
                

                const myOptions = {
            headers: {
                'User-Agent': 'Mozilla/5.0',
                'Content-Type': 'application/json',
                'X-Requested-With': 'ums.lovely.university',
                'Referer': 'http://localhost:8080/',
                'Sec-Fetch-Site': 'cross-site',
            }
        };

        axios.post('https://ums.lpu.in/umswebservice/umswebservice.svc/Testing', {
            UserId: regId,
            password: password,
            Identity: 'aphone',
            DeviceId: 'b5d2f187616d3553',
            PlayerId: 'eRbWwNDk7FQ:APA91bHFbi-o47DsVXwvwoUF6oewl_G-4AE5WZjtgQyztLmt6WYHj16PERtOKKUrxi9AnoNV2j9VMllTzEWG_94VQvttKcjgn_IdK9aijw3anYoZfe6PxYmZhNGOjIOYb1CskB5RAgsc'
        }, myOptions)
            .then((response) =>{

            	const result = response.data.TestingResult[0];
            	if(result.AccessToken.length === 0)
            	{
            		//bool=false;
            		return res.send("login error");
            	}
            	else
            	{
            	   const type = result.UserType;
            	   if(type === 'Student')
            	   {
            	   	  const access_token = result.AccessToken;
                      const device_id = 'b5d2f187616d3553';

                      axios.get(thirdUMS+""+regId+"/"+access_token+"/"+device_id)
                      .then(async (response1) => {
                            const result1 = response1.data[0];
                            axios.get("http://localhost:7777/signInData",{
                            data: {
                            regNo: regId,
                            name: result1.StudentName,
                            }
                            })
                            .then(response2=>
                            {
                            	const myData=response2.data;
                            	if(myData !== 'error')
                            	{
                            		res.cookie("info", myData, {expire: 400000 + Date.now()});
                            		res.send(myData);
                            	}
                            	else
                            	{
                            		res.send('login error');
                            	}
                            }, (error) =>
                            {
                            	res.send('Internal Api Error in Reinitialization.......');
                            });
                            
                        },(error) => {
            	res.send("Incorrect registration ID or password");
            });


            	   }
            	   else
            	   {
            	   	  res.send("login error");
            	   }

            	   

            	   
                }
               
            }, (error) => {
            	res.send("Incorrect registration ID or password");
            });

            }, (error) => {
                res.send('Internal Api Error in Reinitialization.......');
            });

            

    }
    else
    {
    	res.send("Have a good day!");
    }
     

});



app.listen(port, () => console.log(`Example app listening on port ${port}!`));