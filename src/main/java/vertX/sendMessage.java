package vertX;

import io.vertx.core.http.Cookie;
import io.vertx.core.http.HttpServerRequest;
import io.vertx.core.http.HttpServerResponse;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.mongo.MongoClient;
import io.vertx.ext.web.RoutingContext;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class sendMessage
{
  void sendMessageData(RoutingContext req, MongoClient mongoClient)
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
            DateTimeFormatter dtf = DateTimeFormatter.ofPattern("HH:mm yyyy/MM/dd");
            LocalDateTime now = LocalDateTime.now();
            String date= dtf.format(now).toString();
            JsonObject jsonObjectB=req.getBodyAsJson();
            String recieverRegNo=jsonObjectB.getString("regNo");
            String senderPic=allA.result().getString("pp");
            String senderName=allA.result().getString("name");
            String message=jsonObjectB.getString("message");

            JsonObject jsonObjectC=new JsonObject()
              .put("senderName",senderName)
              .put("senderPic",senderPic)
              .put("message",message)
              .put("date",date);
            JsonObject jsonObjectD=new JsonObject().put("$push",new JsonObject().put("message",jsonObjectC));
            JsonObject jsonObjectE=new JsonObject().put("regNo",recieverRegNo);
            mongoClient.updateCollection("userInfo",jsonObjectE,jsonObjectD,allB->
            {
              if(allB.succeeded())
              {
                response.end("OK");
              }
              else
              {
                response.end("Something went wrong");
              }
            });
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
