<div class="ui relaxed list">
  <div class="item">
    <img class="ui avatar image" src="${pp}">
    <div class="content">
      <a class="header"> ${name} <div class="ui red horizontal label">${today}</div></a>
    </div>
      <div class="ui fluid icon input">
        <textarea id="text${ID}" style="position: relative; left:33px; width: 60%; box-shadow: 4px 4px 2px 0px rgba(0,0,0,0.35); border-radius: 5px; outline: none" placeholder="Enter you answer"></textarea>
      <br>
        <br>
        <div style="position: relative; left: 33px;">
      <button id="save${ID}" style="box-shadow: 6px 6px 2px 0px rgba(0,0,0,0.45)" class="circular ui green icon button">
        <i class="icon save outline"></i>
      </button>
      <button id="cancel${ID}" style="box-shadow: 6px 6px 2px 0px rgba(0,0,0,0.45)" class="circular ui red icon button">
        <i class="icon cut"></i>
      </button>
        </div>
    </div>
  </div>
</div>


<script>

  $(function() {
    $("#save${ID}").click(function () {
      var text = $("#text${ID}").val();
      text=text.trim();
      if(text.length>0) {
        console.log("HERE1");
        $.ajax({

          url: "/editData",

          data:
            {
              ID: ${ID},
              data: text,
            },
          success: function (data) {
            console.log(data);
            if (data === "OK") {
              console.log(data+" "+"gotit");
              addNew();
            } else {
              location.reload();
            }
          }
        });
      }
      else
      {
        alert("I think no answer exist without any character, press the cancel button.");
      }
    });

    $("#cancel${ID}").click(function () {
    addNew();
    });

    function addNew()
    {
      console.log("Sending data");
      $.ajax({

        url: "/answerData",

        data:
          {
            data: ${ID},
          },
        success: function(data)
        {
          console.log("Got the data");
          if(data!=="login error" && data!=='not found')
          {
            $("#answerList${ID}").empty();
            $("#answerList${ID}").append(data);
          }
          else
          {
            location.reload();
          }
        }
      });
    };

  });
</script>
