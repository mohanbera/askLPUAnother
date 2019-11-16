package vertX;

import io.vertx.core.Context;
import io.vertx.core.http.Cookie;
import io.vertx.core.http.HttpServerRequest;
import io.vertx.core.http.HttpServerResponse;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.mongo.MongoClient;
import io.vertx.ext.web.RoutingContext;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Stack;

public class sendNotifications
{
  void sendNotificationData(RoutingContext req, MongoClient mongoClient)
  {
    HttpServerRequest request=req.request();
    HttpServerResponse response=req.response();

    int cookieCount1=request.cookieCount();
    if(cookieCount1>0)
    {
      Cookie cookie=request.getCookie("info");
      if(cookie!=null)
      {
        String code=cookie.getValue();
        JsonObject jsonObjectA=new JsonObject().put("code",code);
        mongoClient.findOne("userInfo",jsonObjectA,null,allA->
        {
          if(allA.succeeded() && allA.result()!=null)
          {
            if(allA.result().containsKey("admin"))
            {
              JsonObject jsonObjectB=req.getBodyAsJson();
              String regNums=jsonObjectB.getString("regNums");
              boolean sendToAll=jsonObjectB.getBoolean("sendToAll");

              String notificationMessage=jsonObjectB.getString("notificationMessage");
              String senderName= jsonObjectB.getString("senderName");
              System.out.println(senderName);

              DateTimeFormatter dtf = DateTimeFormatter.ofPattern("HH:mm yyyy/MM/dd");
              LocalDateTime now = LocalDateTime.now();
              String date= dtf.format(now).toString();

              JsonObject notificationObject=new JsonObject().put("senderName",senderName).put("date",date).put("notification",notificationMessage);

              if(sendToAll)
              {
                JsonObject jsonObjectC=new JsonObject();

                mongoClient.find("userInfo",jsonObjectC,allABA->
                {
                  if(allABA.succeeded())
                  {
                    for(JsonObject jsonObject000:allABA.result())
                    {
                      String regNo=jsonObject000.getString("regNo");
                      JsonObject jsonObjectAC=new JsonObject().put("regNo",regNo);
                      JsonObject jsonObjectD=new JsonObject().put("$push",new JsonObject().put("notification",notificationObject));
                      mongoClient.updateCollection("userInfo",jsonObjectAC,jsonObjectD,allAB->
                      {
                        if(allAB.succeeded())
                        {
                          response.end("OK");
                        }
                        else
                        {
                          response.end("login error");
                        }
                      });
                    }
                  }
                  else
                  {
                    response.end("login error");
                  }
                });
              }
              else
              {
                String[] regArr1=regNums.split(" ");
                int len1=regArr1.length;
                Stack<Integer> stack=new Stack<>();
                for(int i=0;i<len1;i++)
                {
                  String regNo=regArr1[i].trim();
                  stack.push(i);
                  JsonObject jsonObject=new JsonObject().put("regNo",regNo);
                  JsonObject jsonObject1=new JsonObject().put("$push",new JsonObject().put("notification",notificationObject));
                  mongoClient.updateCollection("userInfo",jsonObject,jsonObject1,allB->
                  {
                    if(allB.succeeded())
                    {
                      if(!response.ended())
                      {
                        int last=stack.pop();
                        if(last==len1-1)
                        {
                          response.end("OK");
                        }
                      }
                    }
                    else
                    {
                      response.end("login error");
                    }
                  });
                }
              }
            }
            else
            {
              response.end("login error");
            }
          }
          else
          {
            response.end("login error");
          }
        });
      }
      else
      {
        response.end("login error");
      }
    }
    else
    {
      response.end("login error");
    }
  }
}
