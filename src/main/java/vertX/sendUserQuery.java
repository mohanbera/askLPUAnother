package vertX;

import io.vertx.core.json.JsonObject;
import io.vertx.ext.mongo.MongoClient;
import io.vertx.ext.web.RoutingContext;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class sendUserQuery
{
  void sendUserQueryData(RoutingContext req, MongoClient mongoClient)
  {
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("HH:mm yyyy/MM/dd");
    LocalDateTime now = LocalDateTime.now();
    String date= dtf.format(now).toString();

    JsonObject jsonObject=req.getBodyAsJson();
    jsonObject.put("date",date);
    mongoClient.insert("outQues",jsonObject,allA->
    {
      if(allA.succeeded())
      {
        req.response().end("OK");
      }
      else
      {
        req.response().end("login error");
      }
    });
  }
}
