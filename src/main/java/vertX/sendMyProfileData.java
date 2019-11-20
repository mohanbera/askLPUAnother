package vertX;

import io.vertx.core.json.JsonObject;
import io.vertx.ext.mongo.MongoClient;
import io.vertx.ext.web.RoutingContext;

public class sendMyProfileData
{
  public void sendProfileData(RoutingContext req, MongoClient mongoClient)
  {
    JsonObject jsonObject=new JsonObject();
    jsonObject.put("regNo","11612306");
    mongoClient.findOne("me",jsonObject,null,allA->
    {
      if(allA.succeeded())
      {
        JsonObject jsonObjectA=allA.result();
        req.response().end(jsonObjectA.encodePrettily());
      }
      else
      {
        req.response().end("Some problem occurred");
      }
    });
  }
}
