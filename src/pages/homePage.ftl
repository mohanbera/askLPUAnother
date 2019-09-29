<!DOCTYPE html>
<html id="html1" lang="en">
<head>
  <meta charset="UTF-8">
  <title>Title</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/1.11.8/semantic.min.css"/>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/1.11.8/semantic.min.js"></script>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
  <script type="text/javascript">
    $(document).ready(function(){

      //$("body").css('background-image','url(/background)');
      var signIn=true;
      var signUp=false;

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

<script>
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

</script>

</body>
</html>

