package vertX;

import io.vertx.core.http.Cookie;
import io.vertx.core.http.HttpServerRequest;
import io.vertx.core.http.HttpServerResponse;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.mongo.MongoClient;
import io.vertx.ext.web.RoutingContext;

public class getUsetQuery
{
  void showUserQuery(RoutingContext req, MongoClient mongoClient)
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
          if(allA.succeeded() && allA.result()!=null && allA.result().containsKey("admin"))
          {
            JsonObject jsonObjectB=new JsonObject();
            mongoClient.find("outQues",jsonObjectB,allB->
            {
              if(allB.succeeded())
              {
                JsonArray jsonArray=new JsonArray();
                for(JsonObject jsonObject:allB.result())
                {
                  jsonArray.add(jsonObject);
                }
                response.putHeader("Content-Type","application-json");
                response.end(jsonArray.encodePrettily());
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
