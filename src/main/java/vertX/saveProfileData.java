package vertX;

import io.vertx.core.http.Cookie;
import io.vertx.core.http.HttpServerRequest;
import io.vertx.core.http.HttpServerResponse;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.mongo.MongoClient;
import io.vertx.ext.web.RoutingContext;

public class saveProfileData
{
  void saveProfile(RoutingContext req, MongoClient mongoClient)
  {
    HttpServerRequest request = req.request();
    HttpServerResponse response = req.response();


    int cookieCount=request.cookieCount();
    if(cookieCount>0)
    {
      Cookie cookie=request.getCookie("info");
      if(cookie!=null)
      {
        String code=cookie.getValue();
        JsonObject jsonObjectA=new JsonObject().put("code",code);
        mongoClient.findOne("userInfo",jsonObjectA,null,all1->
        {
          if(all1.succeeded() && all1.result()!=null)
          {
            String regNo=all1.result().getString("regNo");
            JsonObject requestData=req.getBodyAsJson();
            String regNoFromRequest=requestData.getString("regNo");
            if(regNo.equals(regNoFromRequest))
            {
              JsonObject jsonObjectB=new JsonObject().put("regNo",regNo);
              JsonObject jsonObjectC=new JsonObject();
              jsonObjectC.put("$set",new JsonObject().put("profile",requestData.getJsonObject("profile"))
              .put("education",requestData.getJsonArray("education"))
                .put("skills",requestData.getJsonArray("skills"))
                .put("achievements",requestData.getJsonArray("achievements"))
                .put("projects",requestData.getJsonArray("projects"))
                .put("platforms",requestData.getJsonArray("platforms"))
                .put("connection",requestData.getJsonArray("connection"))
              );

              mongoClient.updateCollection("userInfo",jsonObjectB,jsonObjectC,all2->
              {
                if(all2.succeeded())
                {
                  response.end("OK");
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
