<div class="ui divider"></div>
<#list ans as str>
  <div id="div${str.ID}" style="position: relative; display: inline-block; width: 97%; background-color: white; box-shadow: 4px 4px 2px 0px rgba(0,0,0,0.35)" class='ui label'>
    <div style="float: left">
      <div class="ui purple horizontal label">Question</div>
      <div class="ui large label">${str.name}</div>
    </div>
    <div style="position:relative; float: right;">
      <a id=${str.buttonID} class="ui blue basic label">See Answers</a>
      <a class="ui pointing red basic label">By ${str.author}</a>
      <a class="ui teal tag label">${str.views}</a>
      <a class="ui orange label">
        <i class="calendar alternate outline icon"></i>${str.date}</a>
      <button hidden id="edit${str.ID}" style=" float: bottom; box-shadow: 6px 6px 2px 0px rgba(0,0,0,0.45);" class="circular ui green icon button">
        <i class="icon pencil alternate"></i>
      </button>
      <script>
        var bool${str.ID}=false;

        $(function(){


            $("#${str.buttonID}").click(function ()
            {
              if(bool${str.ID}===false)
              {
                $("#edit${str.ID}").visible=true;
                $("#edit${str.ID}").show();
                bool${str.ID} = true;
                $("#div${str.ID}").append("<br>");
                $.ajax({

                  url: "/answerData",

                  data:
                    {
                      data:${str.ID},
                      count:"1",
                    },
                  success: function(data)
                  {
                    if(data!=='not found')
                    {
                      $("#answerList${str.ID}").empty();
                      $("#answerList${str.ID}").append(data);
                    }
                  }
                });
              }
            });

          var count1=0;
          $("#edit${str.ID}").click(function () {
            if (count1 === 0) {
            count1=count1+1;
              $.ajax({

                url: "/editAnswer",

                data:
                  {
                    data: ${str.ID},
                  },
                success: function(data)
                {
                  if(data!=="login error")
                  {
                    $("#answerList${str.ID}").append(data);
                  }
                  else
                  {
                    location.reload();
                  }
                }
              });
          }
          });


        });

      </script>

    </div>
    <br>
    <div class="ui divider"></div>
    <div id="answerList${str.ID}"></div>
  </div>
  <div class="ui divider"></div>
</#list>


