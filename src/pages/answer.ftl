<#list ans as str>
  <div class="ui relaxed list">
    <div class="item">
      <img class="ui avatar image" src="${str.pp}">
      <div class="content">
        <a class="header">${str.author} <div class="ui red horizontal label">${str.date}</div></a>
        <div class="description"><b>${str.name}</b></div>
      </div>
      <a id="like${str.ID}" style='color: white; box-shadow: 6px 6px 2px 0px rgba(0,0,0,0.45);' class="ui circular label">${str.like}</a>
      <a id="disLike${str.ID}" style='color: white; box-shadow: 6px 6px 2px 0px rgba(0,0,0,0.45);' class="ui circular label">${str.dislike}</a>
    </div>
  </div>
  <script>
    $(function(){

      $("#like${str.ID}").click(function () {
        $.ajax({

          url: "/like",

          data:
            {
              ansID:${str.ID},
            },
          success: function(data)
          {
            if(data==='not eligible' || data==='error')
            {
              alert(data);
            }
            else if(data==='login error')
            {
              location.reload();
            }
            else
            {
              var num1=$("#like${str.ID}").html();
              var num2=parseInt(num1);
              num2=num2+1;
              $("#like${str.ID}").html(num2);
            }
          }
        });
      });

      $("#disLike${str.ID}").click(function () {
        $.ajax({

          url: "/dislike",

          data:
            {
              ansID:${str.ID},
            },
          success: function(data)
          {
            if(data==='not eligible' || data==='error')
            {
              alert(data);
            }
            else if(data==='login error')
            {
              location.reload();
            }
            else
            {
              var num1=$("#disLike${str.ID}").html();
              var num2=parseInt(num1);
              num2=num2+1;
              $("#disLike${str.ID}").html(num2);
            }
          }
        });
      });

    });
  </script>
</#list>

