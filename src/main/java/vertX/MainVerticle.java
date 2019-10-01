package vertX;

import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import io.vertx.core.AbstractVerticle;
import io.vertx.core.Context;
import io.vertx.core.Promise;
import io.vertx.core.Vertx;
import io.vertx.core.http.Cookie;
import io.vertx.core.http.HttpServer;
import io.vertx.core.http.HttpServerRequest;
import io.vertx.core.http.HttpServerResponse;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.mongo.MongoClient;
import io.vertx.ext.web.Router;

import java.io.*;
import java.net.URL;
import java.time.LocalDate;
import java.util.*;

public class MainVerticle extends AbstractVerticle
{

  ClassLoader classLoader=getClass().getClassLoader();

  MongoClient mongoClient=null;
  JsonObject mongoconfig=null;
  Configuration configuration=new Configuration();

  Template template1=configuration.getTemplate("src/pages/page.ftl");
  Template template2=configuration.getTemplate("src/pages/answer.ftl");
  Template template3=configuration.getTemplate("src/pages/homePage.ftl");
  Template template5=configuration.getTemplate("src/pages/editPage.ftl");
  Template template7=configuration.getTemplate("src/pages/newQuesEditor.ftl");

  /////////////////////// for storing the keywords /////////////////////////////////////
  HashMap<String, HashSet<Integer>> keyWords=new HashMap<>();

  public MainVerticle() throws IOException
  {
  }
  /////////////////////////////////////////////////////////////////////////////////////


  @Override
  public void init(Vertx vertx, Context context)
  {
    String uri = "mongodb://localhost:27017";
    String db = "mydb";

    mongoconfig = new JsonObject()
      .put("connection_string", uri)
      .put("db_name", db);

    mongoClient = MongoClient.createShared(vertx, mongoconfig);

    ////////////// in the start insert all the keywords in the keyWord hashMap /////////
    JsonObject jsonObject=new JsonObject();
    mongoClient.find("ques",jsonObject,listAsyncResult ->
    {
      if(listAsyncResult.succeeded())
      {
        for(JsonObject jsonObject1:listAsyncResult.result())
        {
          String str1=jsonObject1.getString("name");
          str1=str1.toLowerCase();
          int ID=Integer.parseInt(jsonObject1.getString("ID"));
          String[] terms = str1.split("[\\s@&.?$+-]+");
          for(int i=0;i<terms.length;i++)
          {
            String key=terms[i];
            if(keyWords.containsKey(key))
            {
              HashSet<Integer> hashSet=keyWords.get(key);
              hashSet.add(ID);
              keyWords.put(key,hashSet);
            }
            else
            {
              HashSet<Integer> hashSet=new HashSet<>();
              hashSet.add(ID);
              keyWords.put(key,hashSet);
            }
          }
        }
      }



    });

  }

  /////////////////////////// for storing the user info hash code ///////////////////////////
  @Override
  public void start(Promise<Void> startPromise) throws Exception {

    ////////////////////////////////// For Mongo Connection ////////////////////////////////

    startPromise.complete();

    ////////////////////////////////// Creating a new vertex /////////////////////////////

    Vertx vertx1=Vertx.vertx();
    HttpServer httpServer=vertx1.createHttpServer();
    Router router=Router.router(vertx1);
    httpServer.requestHandler(router).listen(7777);



    //////////////////////////// for just testing ;) ///////////////////



    router.get("/test").handler(req->
    {
      JsonObject query=new JsonObject().put("name","first");
      JsonObject jsonObject = new JsonObject();
      jsonObject.put("$push", new JsonObject().put("team","BAN"));

      mongoClient.updateCollection("test",query,jsonObject,res->
      {
        if (res.succeeded())
        {
          System.out.println("YO");
        }
        else
        {
          System.out.println("NO");
        }
      });

      JsonObject query1=new JsonObject().put("name","first");

      mongoClient.find("test",query1,res->
      {
        String ans1="";
        if(res.succeeded())
        {
          JsonArray jsonArray=(res.result().get(0).getJsonArray("team"));
          for(Object o:jsonArray)
          {
            ans1+=o.toString();
          }
        }
        req.response().end(ans1);
      });
    });






    ///////////////////////////////// Routing the main page //////////////////////////////
    router.get("/json").handler(req->
    {

      mongoClient.find("mydb", new JsonObject().put("user", "Mohan").put("surname","rider"), res -> {
        System.out.println(res.result()+"");
      });

      HttpServerResponse response=req.response();
      response.putHeader("Content-Type","application/json; charset=UTF8");
      JsonObject jsonObject=new JsonObject();
      jsonObject.put("Hello","Java Vert.x");
      String[] strArr1={"Hackerrank","Codechef","Hackerearth"};
      JsonArray jsonArray=new JsonArray(Arrays.asList(strArr1));
      jsonObject.put("Platforms",jsonArray);
      response.end(jsonObject.encodePrettily());
    });


    router.get("/welcome").handler(req->
    {
      HttpServerResponse response=req.response();
      response.putHeader("Content-Type","text/html");
      response.end("<h1><p align='cente'>Welcome</p></h1>");
    });

    //////////////////////////// For handling the login information ////////////////////////
    router.get("/signInData").handler(req->
    {
      HttpServerResponse response = req.response();
      HttpServerRequest request=req.request();
      String regNo=request.getParam("regNo");
      String password=request.getParam("password");
      mongoClient.findOne("userInfo", new JsonObject().put("regNo",regNo).put("password",password), null, res -> {
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
              res1.cause().printStackTrace();
              req.response().sendFile("src/pages/login.html");
            }
            else
            {
              response.addCookie(Cookie.cookie("info",uuids));
              HashMap<String,String> hashMap=new HashMap<>();
              String name=res.result().getString("name");
              String pp=res.result().getString("pp");
              hashMap.put("name",name);
              hashMap.put("pp",pp);

              returnHomeTemplate(req.response(),hashMap);
            }
          });
        }
        else
        {
          response.end("error");
        }
      });
    });

    router.get("/home").handler(req->
    {

      HttpServerResponse response=req.response();
      response.putHeader("Content-Type","text/html");
      response.sendFile("src/pages/Home.html");
    });

    ///////////////////////////// for serving the login background ////////////////////////
    router.get("/background").handler(req->
    {
      Random random=new Random();
      int num1=random.nextInt(3);
      num1+=1;
      HttpServerResponse response=req.response();
      response.putHeader("Content-Type","image/jpg");
      response.sendFile("src/images/background"+num1+".jpg");
    });

    ////////////////////////// for handling home page /////////////////////////////////////
    router.get("/").handler(req->
    {
      int cookieCount1=req.cookieCount();
      if(cookieCount1==0)
      {
        req.response().sendFile("src/pages/login.html");
      }
      else
      {
        Cookie cookie=req.getCookie("info");
        String code=cookie.getValue();

        JsonObject jsonObject=new JsonObject().put("code",code);
        mongoClient.findOne("userInfo",jsonObject,null,res->
        {
          if (res.succeeded())
          {
            if(res.result()==null)
            {
              req.response().sendFile("src/pages/login.html");
            }
            else
            {
              HashMap<String,String> hashMap=new HashMap<>();
              String name=res.result().getString("name");
              String pp=res.result().getString("pp");
              hashMap.put("name",name);
              hashMap.put("pp",pp);

              returnHomeTemplate(req.response(),hashMap);
            }
          }
          else
          {
            req.response().sendFile("src/pages/login.html");
          }
        });
      }
    });


    router.get("/hello").handler(req->
    {

    });



    /////////////////////////// For handling the new signUp information ////////////////////////////
    router.get("/signUpData").handler(req->
    {
      HttpServerRequest request=req.request();
      String regNo=request.getParam("regNo");
      String fullName=request.getParam("fullName");
      String email=request.getParam("email");
      String password=request.getParam("password");
      req.response().end("OK");
    });

    ////////////////////////////for handling the edit answer //////////////////////////////
    router.get("/editAnswer").handler(req->
    {

      HttpServerRequest request=req.request();
      HttpServerResponse response=req.response();
      int count1=request.cookieCount();
      if(count1>0)
      {
        Cookie cookie=request.getCookie("info");
        if(cookie==null)
        {
          sendErrorMessage(response);
        }
        else
        {
          String code=cookie.getValue();
          JsonObject jsonObject=new JsonObject().put("code",code);
          mongoClient.findOne("userInfo",jsonObject,null,res1->
          {
            if(res1.succeeded())
            {
              if(res1.result()==null)
              {
                sendErrorMessage(response);
              }
              else
              {
                String name=res1.result().getString("name");
                String pp=res1.result().getString("pp");
                String today= LocalDate.now().toString();
                String ID=request.getParam("data");
                HashMap<String,String> hashMap=new HashMap<>();
                hashMap.put("name",name);
                hashMap.put("pp",pp);
                hashMap.put("today",today);
                hashMap.put("ID",ID);
                returnEditPage(response,hashMap);
              }
            }
            else
            {
              sendErrorMessage(response);
            }
          });

        }
      }
      else
      {
        sendErrorMessage(response);
      }
    });


    router.get("/answerData").handler(req->
    {
      HttpServerRequest request=req.request();
      HttpServerResponse response=req.response();
      String ID=request.getParam("data");

      JsonObject jsonObject=new JsonObject().put("ID",ID);

      ArrayList<HashMap<String,String>> arrayList=new ArrayList<>();
      mongoClient.findOne("ques",jsonObject,null,res->
      {
        if(res.succeeded() && res.result().getJsonArray("answers").size()>0)
        {
          JsonArray jsonArray=res.result().getJsonArray("answers");
          ArrayList<Integer> arrayList1=new ArrayList<>();
          for(Object object:jsonArray)
          {
            String answerID=object.toString();
            JsonObject jsonObject1=new JsonObject().put("ID",answerID);
            mongoClient.findOne("ans",jsonObject1,null,res1->
            {
              String name="";
              String author="";
              String date="";
              String like="";
              String dislike="";
              String pp="";
              if(res1.succeeded())
              {
                JsonObject jsonObject2=res1.result();
                HashMap<String,String> hashMap=new HashMap<>();
                name=jsonObject2.getString("name");
                author=jsonObject2.getString("author");
                date=jsonObject2.getString("date");
                like=jsonObject2.getString("like");
                dislike=jsonObject2.getString("dislike");
                pp=jsonObject2.getString("pp");

                hashMap.put("ID",answerID);
                hashMap.put("name",name);
                hashMap.put("author",author);
                hashMap.put("date",date);
                hashMap.put("like",like);
                hashMap.put("dislike",dislike);
                hashMap.put("pp",pp);
                arrayList.add(hashMap);
              }
              else
              {
                response.end("not found");
              }
              arrayList1.add(1);
              if(arrayList1.size()==jsonArray.size())
              {
                Collections.sort(arrayList, (o1, o2) -> Integer.parseInt(o2.get("like"))-Integer.parseInt(o1.get("like")));
                if(!response.ended())
                {
                  returnQuestionAnswers(response,arrayList,ID);
                }
              }
            });
          }
        }
        else
        {
          response.end("not found");
        }
      });
    });


    //////////////////////////// for handling the search queries ////////////////////////////////////

    router.get("/searchData").handler(req->
    {
      HttpServerRequest request=req.request();
      HttpServerResponse response=req.response();

      String data=request.getParam("data");
      ArrayList<HashMap<String,String>> arrayList=new ArrayList<>();
      data=data.toLowerCase();
      String[] terms = data.split("[\\s@&.?$+-]+");

      HashMap<Integer,Integer> keyWordCount=new HashMap<>();

      for(int i=0;i<terms.length;i++)
      {
        String key=terms[i];
        if(keyWords.containsKey(key))
        {
          HashSet<Integer> hashSet1=keyWords.get(key);
          for(int num00:hashSet1)
          {
            if(keyWordCount.containsKey(num00))
            {
              keyWordCount.put(num00,keyWordCount.get(num00)+1);
            }
            else
            {
              keyWordCount.put(num00,1);
            }
          }
        }
      }

      PriorityQueue<Integer> priorityQueue=new PriorityQueue<>(new Comparator<Integer>()
      {
        @Override
        public int compare(Integer o1, Integer o2)
        {
          return keyWordCount.get(o2)-keyWordCount.get(o1);
        }
      });

      PriorityQueue<Integer>  priorityQueue1=new PriorityQueue<>();
      for(int num00:keyWordCount.keySet())
      {
        priorityQueue.add(num00);
        priorityQueue1.add(num00);
      }


      while (!priorityQueue.isEmpty())
      {
        int num00=priorityQueue.poll();
        JsonObject jsonObject=new JsonObject();
        jsonObject.put("ID",String.valueOf(num00));

        mongoClient.findOne("ques",jsonObject,null,res->{
          if(priorityQueue1.size()>0)
          {
            priorityQueue1.poll();
          }
          String date="";
          String views="";
          String author="";
          if(res.succeeded())
          {
            String str1 = res.result().getString("name");
            date=res.result().getString("date");
            views=res.result().getInteger("views").toString();
            author=res.result().getString("author");
            HashMap<String,String> hm=new HashMap<>();
            hm.put("name",str1);
            hm.put("ID",String.valueOf(num00));
            hm.put("buttonID","A"+num00);
            hm.put("date",date);
            hm.put("views",views);
            hm.put("author",author);
            arrayList.add(hm);
          }
          if(priorityQueue1.isEmpty())
          {
            if(!response.closed() && !response.ended())
            {
              returnSearchData(response,arrayList);
            }
          }
        });
      }
    });

    /////////////////////////////////// to handle save and cancel action ///////////////////////////
    router.get("/editData").handler(req->
    {

      HttpServerRequest request=req.request();
      HttpServerResponse response=req.response();

      int cookieCount=request.cookieCount();
      if(cookieCount==0)
      {
        sendErrorMessage(response);
      }
      else
      {
        Cookie cookie=request.getCookie("info");
        if(cookie==null)
        {
          sendErrorMessage(response);
        }
        else
        {
          String code=cookie.getValue();
          JsonObject jsonObject=new JsonObject().put("code",code);
          mongoClient.findOne("userInfo",jsonObject,null,res1->
          {
            if(res1.succeeded())
            {
              if(res1.result()==null)
              {
                sendErrorMessage(response);
              }
              else
              {
                  JsonObject jsonObject1=new JsonObject().put("ID","777");
                  mongoClient.findOne("curInfo",jsonObject1,null,res2->
                  {
                    if(res2.succeeded())
                    {
                      String ansID=res2.result().getString("ansID");
                      String nextAnsID=String.valueOf(Integer.parseInt(ansID)+1);
                      JsonObject jsonObject2=new JsonObject().put("ID","777");
                      JsonObject jsonObject3=new JsonObject().put("$set",new JsonObject().put("ansID",nextAnsID));
                      mongoClient.updateCollection("curInfo",jsonObject2,jsonObject3,res3->
                      {
                        if (res3.succeeded())
                        {
                          String name=request.getParam("data");
                          String regNo=res1.result().getString("regNo");
                          String author=res1.result().getString("name");
                          String date=LocalDate.now().toString();
                          String pp=res1.result().getString("pp");
                          String like="0";
                          String dislike="0";
                          ArrayList<String> likeArr1=new ArrayList<>();
                          likeArr1.add(regNo);
                          ArrayList<String> dislikeArr1=new ArrayList<>();
                          dislikeArr1.add(regNo);
                          JsonArray likeID= new JsonArray(likeArr1);
                          JsonArray dislikeID=new JsonArray(dislikeArr1);

                          JsonObject document=new JsonObject()
                            .put("ID",ansID)
                            .put("name",name)
                            .put("author",author)
                            .put("date",date)
                            .put("pp",pp)
                            .put("like",like)
                            .put("dislike",dislike)
                            .put("likeID",likeID)
                            .put("dislikeID",dislikeID);
                          mongoClient.insert("ans",document,res5->
                          {
                            if(res5.succeeded())
                            {
                              String quesIDFromClient=request.getParam("ID");
                              JsonObject jsonObject5=new JsonObject().put("ID",quesIDFromClient);
                              JsonObject jsonObject7=new JsonObject().put("$push",new JsonObject().put("answers",ansID));
                              mongoClient.updateCollection("ques",jsonObject5,jsonObject7,res7->
                              {
                                if(res7.succeeded())
                                {
                                  response.end("OK");
                                  //JsonObject jsonObject11=new JsonObject().put()
                                }
                                else
                                {
                                  sendErrorMessage(response);
                                }
                              });
                            }
                            else
                            {
                              sendErrorMessage(response);
                            }
                          });
                        }
                        else
                        {
                          sendErrorMessage(response);
                        }
                      });
                    }
                    else
                    {
                      sendErrorMessage(response);
                    }
                  });
              }
            }
            else
            {
              sendErrorMessage(response);
            }
          });
        }
      }

    });


    /////////////////////////////  action for like button //////////////////////////////////

    router.get("/like").handler(all->
    {
      HttpServerRequest request=all.request();
      HttpServerResponse response=all.response();

      int count1=request.cookieCount();
      if(count1>0)
      {
        Cookie cookie=request.getCookie("info");
        if(cookie!=null)
        {
          String code=cookie.getValue();
          JsonObject jsonObject=new JsonObject().put("code",code);
          mongoClient.findOne("userInfo",jsonObject,null,res1->
          {
            if(res1.succeeded())
            {
              if(res1.result()!=null)
              {
                String regNo=res1.result().getString("regNo");
                String ansID=request.getParam("ansID");
                JsonObject jsonObject1=new JsonObject().put("ID",ansID);
                mongoClient.findOne("ans",jsonObject1,null,res2->
                {
                  if(res2.succeeded())
                  {
                    if(res2.result()!=null)
                    {
                      String like=res2.result().getString("like");
                      int likes=Integer.parseInt(like);
                      JsonArray jsonArray=res2.result().getJsonArray("likeID");
                      HashSet<String> hashSet=new HashSet<>();
                      for(Object jsonObject2:jsonArray)
                      {
                        hashSet.add(jsonObject2.toString());
                      }
                      if(hashSet.contains(regNo))
                      {
                        response.end("not eligible");
                      }
                      else
                      {
                        String newLike=String.valueOf(likes+1);
                        JsonObject jsonObject3=new JsonObject().put("$set",new JsonObject().put("like",newLike));
                        mongoClient.updateCollection("ans",jsonObject1,jsonObject3,res3->
                        {
                          if(res3.succeeded())
                          {
                            JsonObject jsonObject5=new JsonObject().put("$push",new JsonObject().put("likeID",regNo));
                            mongoClient.updateCollection("ans",jsonObject1,jsonObject5,res5->
                            {
                              if(res5.succeeded())
                              {
                                response.end("OK");
                              }
                              else
                              {
                                response.end("error");
                              }
                            });
                          }
                          else
                          {
                            response.end("error");
                          }
                        });
                      }
                    }
                    else
                    {
                      response.end("error");
                    }
                  }
                  else
                  {
                    response.end("error");
                  }
                });
              }
              else
              {
                sendErrorMessage(response);
              }
            }
            else
            {
              sendErrorMessage(response);
            }
          });
        }
        else
        {
          sendErrorMessage(response);
        }
      }
      else
      {
        sendErrorMessage(response);
      }
    });


    ///////////////////////////// for handling dislike action /////////////////////////////

    router.get("/dislike").handler(all->{

      HttpServerRequest request=all.request();
      HttpServerResponse response=all.response();

      int count1=request.cookieCount();
      if(count1>0)
      {
        Cookie cookie=request.getCookie("info");
        if(cookie!=null)
        {
          String code=cookie.getValue();
          JsonObject jsonObject=new JsonObject().put("code",code);
          mongoClient.findOne("userInfo",jsonObject,null,res1->
          {
            if(res1.succeeded())
            {
              if(res1.result()!=null)
              {
                String resgNo=res1.result().getString("regNo");
                String ID=request.getParam("ansID");
                JsonObject jsonObject1=new JsonObject().put("ID",ID);
                mongoClient.findOne("ans",jsonObject1,null,res2->
                {
                  if(res2.succeeded())
                  {
                    if(res2.result()!=null)
                    {
                      String dislike=res2.result().getString("dislike");
                      JsonArray jsonArray=res2.result().getJsonArray("dislikeID");
                      HashSet<String> hashSet=new HashSet<>();
                      for(Object object:jsonArray)
                      {
                        hashSet.add(object.toString());
                      }
                      if(hashSet.contains(resgNo))
                      {
                        response.end("not eligible");
                      }
                      else
                      {
                        JsonObject jsonObject2=new JsonObject().put("ID",ID);
                        JsonObject jsonObject3=new JsonObject().put("$push",new JsonObject().put("dislikeID",resgNo));
                        mongoClient.updateCollection("ans",jsonObject2,jsonObject3,res3->{
                          if(res3.succeeded())
                          {
                            int dislikes=Integer.parseInt(dislike);
                            dislikes++;
                            JsonObject jsonObject5=new JsonObject().put("$set",new JsonObject().put("dislike",String.valueOf(dislikes)));
                            mongoClient.updateCollection("ans",jsonObject2,jsonObject5,res5->
                            {
                              if(res5.succeeded())
                              {
                                response.end("OK");
                              }
                              else
                              {
                                response.end("error");
                              }
                            });
                          }
                          else
                          {
                            response.end("error");
                          }
                        });
                      }
                    }
                    else
                    {
                      response.end("error");
                    }
                  }
                  else
                  {
                    response.end("error");
                  }
                });
              }
              else
              {
                sendErrorMessage(response);
              }
            }
            else
            {
              sendErrorMessage(response);
            }
          });
        }
        else
        {
          sendErrorMessage(response);
        }
      }
      else
      {
        sendErrorMessage(response);
      }
    });
    ///////////////////////////// new question editor /////////////////////////////////////

    router.get("/newQuesEdit").handler(req->{

      HttpServerRequest request=req.request();
      HttpServerResponse response=req.response();

      returnNewQuesEditPage(response);

    });


    /////////////////////////// for adding new Question ///////////////////////////
    router.get("/addNewQues").handler(all->
    {
      HttpServerRequest request=all.request();
      HttpServerResponse response=all.response();

      int count1=request.cookieCount();
      if(count1>0)
      {
        Cookie cookie=request.getCookie("info");
        if(cookie!=null)
        {
          String code=cookie.getValue();
          JsonObject jsonObject=new JsonObject().put("code",code);
          mongoClient.findOne("userInfo",jsonObject,null,res1->
          {
            if(res1.succeeded())
            {
              if(res1.result()!=null)
              {
                JsonObject jsonObject1=new JsonObject().put("ID","777");
                mongoClient.findOne("curInfo",jsonObject1,null,res2->
                {
                  if(!res2.succeeded())
                  {
                    sendErrorMessage(response);
                  }
                  else {
                    if (res2.result() != null) {
                      String ID = res2.result().getString("quesID");
                      String newQuesID = String.valueOf(Integer.parseInt(ID) + 1);
                      String name = request.getParam("data");
                      String date = LocalDate.now().toString();
                      String author = res1.result().getString("name");
                      int views = 0;

                      ArrayList<String> arrayList = new ArrayList<>();
                      JsonArray answers = new JsonArray(arrayList);

                      JsonObject jsonObject2 = new JsonObject()
                        .put("ID", ID)
                        .put("name", name)
                        .put("views", views)
                        .put("answers", answers)
                        .put("date", date)
                        .put("author", author);

                      mongoClient.insert("ques", jsonObject2, res3 ->
                      {
                        if (res3.succeeded()) {
                          JsonObject jsonObject3 = new JsonObject().put("ID", "777");
                          JsonObject jsonObject5 = new JsonObject().put("$set", new JsonObject().put("quesID", newQuesID));
                          mongoClient.updateCollection("curInfo", jsonObject3, jsonObject5, res5 ->
                          {
                            if (res5.succeeded()) {
                              String[] terms = name.split("[\\s@&.?$+-]+");
                              int lenOfTerms = terms.length;
                              for (int i = 0; i < lenOfTerms; i++) {
                                String term = terms[i];
                                term = term.toLowerCase();
                                if (keyWords.containsKey(term)) {
                                  HashSet<Integer> hashSet = keyWords.get(term);
                                  hashSet.add(Integer.parseInt(ID));
                                  keyWords.put(term, hashSet);
                                } else {
                                  HashSet<Integer> hashSet = new HashSet<>();
                                  hashSet.add(Integer.parseInt(ID));
                                  keyWords.put(term, hashSet);
                                }
                              }
                              response.end("OK");
                            } else {
                              sendErrorMessage(response);
                            }

                          });
                        } else {
                          sendErrorMessage(response);
                        }
                      });
                    }
                    else
                    {
                      sendErrorMessage(response);
                    }
                  }
                });
              }
              else
              {
                sendErrorMessage(response);
              }
            }
            else
            {
              sendErrorMessage(response);
            }
          });
        }
        else
        {
          sendErrorMessage(response);
        }
      }
      else
      {
        sendErrorMessage(response);
      }
    });


  }



  ///////////////////////////// checking previous login /////////////////////////////////
  private boolean checkLogin(HttpServerRequest req)
  {
    return false;
  }

  /* ////////////////////////// returning the search data ////////////////////// */
  private void returnSearchData(HttpServerResponse response,ArrayList<HashMap<String,String>> arrayList)
  {
    HashMap<String,Object> hashMap=new HashMap<>();
    hashMap.put("ans",arrayList);
    Writer fileWriter= null;
    try
    {
      fileWriter = new FileWriter(new File("src/pages/page.html"));
    } catch (IOException e)
    {
      e.printStackTrace();
    }
    try
    {
      template1.process(hashMap,fileWriter);
    } catch (TemplateException e)
    {
      e.printStackTrace();
    }
    catch (IOException e)
    {
      e.printStackTrace();
    }
    response.sendFile("src/pages/page.html");
  }
  //////////////////////////////////////////////////////////////////////////////////

  private void returnQuestionAnswers(HttpServerResponse response,ArrayList<HashMap<String,String>> arrayList,String ID)
  {
    HashMap<String,Object> hashMap=new HashMap<>();
    hashMap.put("ans",arrayList);
    hashMap.put("ID",ID);
    Writer fileWriter= null;
    try
    {
      fileWriter = new FileWriter(new File("src/pages/answer.html"));
    } catch (IOException e)
    {
      e.printStackTrace();
    }
    try
    {
      template2.process(hashMap,fileWriter);
    } catch (TemplateException e)
    {
      e.printStackTrace();
    }
    catch (IOException e)
    {
      e.printStackTrace();
    }
    response.sendFile("src/pages/answer.html");
  }

  private void returnHomeTemplate(HttpServerResponse response,HashMap<String,String> hashMap)
  {
    Writer fileWriter= null;
    try
    {
      fileWriter = new FileWriter(new File("src/pages/homePage.html"));
    } catch (IOException e)
    {
      e.printStackTrace();
    }
    try
    {
      template3.process(hashMap,fileWriter);
    } catch (TemplateException e)
    {
      e.printStackTrace();
    }
    catch (IOException e)
    {
      e.printStackTrace();
    }
    response.sendFile("src/pages/homePage.html");
  }

  private void sendErrorMessage(HttpServerResponse response)
  {
    response.end("login error");
  }

  private void returnEditPage(HttpServerResponse response,HashMap<String,String> hashMap)
  {
    Writer fileWriter= null;
    try
    {
      fileWriter = new FileWriter(new File("src/pages/editPage.html"));
    } catch (IOException e)
    {
      e.printStackTrace();
    }
    try
    {
      template5.process(hashMap,fileWriter);
    } catch (TemplateException e)
    {
      e.printStackTrace();
    }
    catch (IOException e)
    {
      e.printStackTrace();
    }
    response.sendFile("src/pages/editPage.html");
  }

  private void returnNewQuesEditPage(HttpServerResponse response)
  {
    HashMap<String,String> hashMap=new HashMap<>();
    Writer fileWriter= null;
    try
    {
      fileWriter = new FileWriter(new File("src/pages/newQuesEditor.html"));
    } catch (IOException e)
    {
      e.printStackTrace();
    }
    try
    {
      template7.process(hashMap,fileWriter);
    } catch (TemplateException e)
    {
      e.printStackTrace();
    }
    catch (IOException e)
    {
      e.printStackTrace();
    }
    response.sendFile("src/pages/newQuesEditor.html");
    response.end();
  }
}
