<!DOCTYPE html>
<html id="html1" lang="en">
<head>
  <meta charset="UTF-8">
  <title>Title</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/1.11.8/semantic.min.css"/>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/1.11.8/semantic.min.js"></script>

  <script type="text/javascript">
    $(document).ready(function(){

      $("body").css('background-image','url(/background)');
      var signIn=true;
      var signUp=false;

      $('.ui.dropdown')
        .dropdown()
      ;

    });
  </script>



</head>
<body id="mainBody">

<a style="position: absolute; top: 10px; right: 10px; box-shadow: 6px 6px 2px 0px rgba(0,0,0,0.45);" class="ui label">
  <img class="ui right spaced avatar image" src="${pp}">
  ${name}
</a>


<button id="addQuestion" style="position: absolute; bottom: 30px;right: 50px; box-shadow: 6px 6px 2px 0px rgba(0,0,0,0.45);" class="circular ui purple icon button">
  <i class="icon edit outline"></i>
</button>

<div id="searchBar" style="left:25%; top:25%; width: 50%; box-shadow: 10px 10px 5px 0px rgba(0,0,0,0.75);" class="ui fluid green action input">
  <input id="search" type="text" placeholder="Search...">
  <div id="searchButton" class="ui button">Search</div>
</div>


<div id="nextDiv" style=" float:left;
overflow-y: auto; overflow-x: hidden;  height: 75%; position: absolute; width: 70%; top: 30%; left: 17%">

</div>

<div style="position:absolute; color: grey;left: 10px; top: 10px; box-shadow: 6px 6px 2px 0px rgba(0,0,0,0.45);" class="ui selection dropdown">
  <input type="hidden" name="select">
  <i class="dropdown icon"></i>
  <div class="default text">Select</div>
  <div class="menu" style="box-shadow: 6px 6px 2px 0px rgba(0,0,0,0.45)">
    <div class="item" onclick="handleShowQuestions('recent')"><i class="clock outline icon"></i>Most Recent</div>
    <div class="item" onclick="handleShowQuestions('mostVisited')"><i class="tag icon"></i>Most Viewed</div>
  </div>
</div>

<script>


  var ansCount1=0;
  function answerCount() {
    ansCount1=ansCount1+1;
    return ansCount1;
  }

  var commentOn=false;
  function commentReset() {
    commentOn=false;
  }
  var set1=new Set();
  function resetSet() {
    ansCount1=0;
    set1=new Set();
  }


  function editComment(id)
  {
    if(!commentOn)
    {
      $.ajax({

        url: "/editComment",

        data:
          {
            ID: id,
          },
        success: function(data)
        {
          if(data==='login error')
          {
            location.reload();
          }
          else
          {
            commentOn=true;
            $('#comments'+id).prepend(data);
          }
        }
      });
    }
  }

  function commentCancelAction(id)
  {
    $("#commentBar"+id).remove();
    commentReset();
  }

  function commentSaveAction(id)
  {
    var comment=$("#commentText"+id).val();
    comment=comment.trim();
    if(comment.length>0)
    {
      $.ajax({

        url: "/saveComment",

        data:
          {
            comment: comment,
            ID:id,
          },
        success: function (data)
        {
          if(data==='login error')
          {
            location.reload();
          }
          else if(data==='error')
          {
            alert("Something went wrong!");
          }
          else
          {
            var num01=$("#showComments"+id).html();
            var yo=num01.split(">");
            var len1=yo.length;
            var num1=parseInt(yo[len1-1]);
            var num2=num1+1;
            $("#showComments"+id).html("<i class=\"comment outline icon \"></i>"+num2);
            $("#commentBar"+id).remove();
            commentReset();

            showCommentsAction(id);
          }

        }
      });
    }
    else
    {
      alert("Comment can't be empty, Please click the cancel button");
    }
  }

  function showCommentsAction(id)
  {

    $.ajax({

      url: "/showComments",

      data:
        {
          ID:id,
        },
      success: function (data)
      {
        if(data==='login error')
        {
          location.reload();
        }
        else if(data==='error')
        {
          alert("Something went wrong!");
        }
        else
        {
          $("#comments"+id).empty();
          $("#comments"+id).append(data);
          commentReset();
        }

      }
    });
  }

  $(function(){



    $("#addQuestion").click(function ()
    {
      $.ajax({

        url: "/newQuesEdit",

        data:
          {
            data: 'yo',
          },
        success: function(data)
        {
          $("#searchBar").hide();
          $("#nextDiv").empty();
          $("#nextDiv").append(data);

        }
      });
    });



    $("#searchButton").click(function () {
      commentReset();
      resetSet();
      $("#nextDiv").empty();

      $.ajax({

        url: "/searchData",

        data:
          {
            data: $("#search").val(),
          },
        success: function(data)
        {

            $("#searchBar").css("top", "5%");
            $("#nextDiv").css("top", "20%");
            $("#nextDiv").append(data);

        }
      });
    });
  });

  function handleShowQuestions(type)
  {
    commentReset();
    resetSet();
    $("#nextDiv").empty();

    $.ajax({

      url: "/showQuestions",

      data:
        {
          type:type,
        },
      success: function(data)
      {

        $("#searchBar").css("top", "5%");
        $("#nextDiv").css("top", "20%");
        $("#nextDiv").append(data);

      }
    });
  }

  function handleRating (id,value,content) {
      var str=id.split(".");
      var ansID=str[1];
      var type="";
      if(str[0][0]==='y')
      {
        type="Y";
      }
      else
      {
        type="B";
      }

        $.ajax({

          url: "/rating",

          data:
            {
              ID: ansID,
              val: value,
              type: type,
            },
          success: function (data) {
            if (data === 'error') {
              alert("something went wrong");
            } else if (data === 'login error') {
              location.reload();
            } else {
              if(type==="Y")
              {
                var str1 = $("#numLike"+ansID).html();
                var strArr = str1.split(">");
                var num1 = parseInt(strArr[strArr.length - 1]);
                var str2=data.split(" ");
                var value1=parseInt(str2[1]);
                num1 = num1 + value1;
                $("#numLike"+ansID).html("<i class=\"heart icon\"></i>"+num1);
              }
              else
              {
                var str1 = $("#numDislike"+ansID).html();
                var strArr = str1.split(">");
                var num1 = parseInt(strArr[strArr.length - 1]);
                var str2=data.split(" ");
                var value1=parseInt(str2[1]);
                num1 = num1 + value1;
                $("#numDislike"+ansID).html("<i class=\"thumbs down outline icon\"></i>"+num1);
              }
            }
          }
        });
  }

</script>


</body>
</html>

