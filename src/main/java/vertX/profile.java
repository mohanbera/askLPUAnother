package vertX;

import io.vertx.core.http.Cookie;
import io.vertx.core.http.HttpServerRequest;
import io.vertx.core.http.HttpServerResponse;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.mongo.MongoClient;
import io.vertx.ext.web.RoutingContext;

public class profile
{
  void sendProfile(RoutingContext req, MongoClient mongoClient)
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
              JsonObject jsonObject1 = req.getBodyAsJson();
              String regNo = jsonObject1.getString("regNo");
              JsonObject jsonObjectB = new JsonObject().put("regNo", regNo);
              mongoClient.findOne("userInfo", jsonObjectB, null, allB ->
              {
                if (allB.succeeded() && allB.result() != null) {
                  JsonObject result = new JsonObject();

                  JsonObject jsonObject = allB.result().getJsonObject("profile");
                  String profileRegNumber=allA.result().getString("regNo");
                  jsonObject.put("regNo",regNo);
                  boolean bool1=false;
                  boolean admin=false;
                  if(profileRegNumber.equals(regNo))
                  {
                    bool1=true;
                    if(allB.result().containsKey("admin"))
                    {
                      admin=true;
                    }
                  }
                  jsonObject.put("admin",admin);
                  result.put("profileOwner",bool1);
                  result.put("profile", jsonObject);
                  result.put("education", allB.result().getJsonArray("education"));
                  result.put("skills", allB.result().getJsonArray("skills"));
                  result.put("projects", allB.result().getJsonArray("projects"));
                  result.put("achievements", allB.result().getJsonArray("achievements"));
                  result.put("platforms", allB.result().getJsonArray("platforms"));
                  result.put("connection", allB.result().getJsonArray("connection"));
                  response.putHeader("Content-Type", "application/json");
                  response.end(result.encodePrettily());
                } else {
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
