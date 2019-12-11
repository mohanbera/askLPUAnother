package vertX;

import io.vertx.core.http.HttpServerRequest;
import io.vertx.core.http.HttpServerResponse;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.mongo.MongoClient;
import io.vertx.ext.web.RoutingContext;

import java.util.UUID;

public class signIn
{
  public void signInData(RoutingContext req, MongoClient mongoClient)
  {
    HttpServerRequest request=req.request();
    HttpServerResponse response=req.response();

    JsonObject jsonObjectA=req.getBodyAsJson();

    String regNo=jsonObjectA.getString("regNo");
    String name=jsonObjectA.getString("name");

    mongoClient.findOne("userInfo", new JsonObject().put("regNo",regNo), null, res -> {
      if(res.result()!=null && res.result().size()>0)
      {
        UUID uuid=new UUID(System.currentTimeMillis(),System.currentTimeMillis());
        String uuids=uuid.toString();
        JsonObject query1=new JsonObject().put("regNo",regNo);
        JsonObject query2=new JsonObject().put("$set",new JsonObject().put("code",uuids));
        mongoClient.updateCollection("userInfo",query1,query2,res1->
        {
          if (!res1.succeeded())
          {
            response.end("error");
          }
          else
          {
            response.end(uuids);
            //returnHomeTemplate(req.response(),hashMap);
          }
        });
      }
      else
      {
        // create new

        UUID uuid=new UUID(System.currentTimeMillis(),System.currentTimeMillis());
        String uuids=uuid.toString();

        JsonObject jsonObject1=new JsonObject();
        jsonObject1.put("name",name);
        jsonObject1.put("regNo", regNo);
        jsonObject1.put("email","");
        jsonObject1.put("password","ums");
        jsonObject1.put("faculty","N");
        jsonObject1.put("pp","https://semantic-ui.com/images/avatar/large/elliot.jpg");
        jsonObject1.put("code",uuids);
        jsonObject1.put("like",0);
        jsonObject1.put("dislike",0);
        JsonObject jsonObject2=new JsonObject().put("image", "https://cdn.vuetifyjs.com/images/cards/road.jpg")
          .put("name", name)
          .put("college", "Lovely Professional University")
          .put("degree","")
          .put("branch", "")
          .put("year","");
        jsonObject1.put("profile", jsonObject2);
        JsonArray jsonArray1=new JsonArray();
        jsonObject1.put("education",jsonArray1);
        jsonObject1.put("skills", jsonArray1);
        jsonObject1.put("projects",jsonArray1);
        jsonObject1.put("achievements",jsonArray1);
        jsonObject1.put("platforms",jsonArray1);
        jsonObject1.put("connection",jsonArray1);
        jsonObject1.put("message",jsonArray1);
        jsonObject1.put("notification",jsonArray1);

        mongoClient.insert("userInfo", jsonObject1, allA->
        {
          if(allA.succeeded())
          {
            response.end(uuids);
          }
          else
          {
            response.end("error");
          }
        });
      }
    });
  }
}
