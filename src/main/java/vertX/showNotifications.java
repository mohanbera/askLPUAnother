package vertX;

import io.vertx.core.Context;
import io.vertx.core.http.Cookie;
import io.vertx.core.http.HttpServerRequest;
import io.vertx.core.http.HttpServerResponse;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.mongo.MongoClient;
import io.vertx.ext.web.RoutingContext;

public class showNotifications
{
  void showNotificationData(RoutingContext req, MongoClient mongoClient)
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
            JsonArray jsonArray=allA.result().getJsonArray("notification");
            JsonObject jsonObject=new JsonObject().put("notifications",jsonArray);
            response.putHeader("Content-Type", "application/json");
            response.end(jsonObject.encodePrettily());
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
