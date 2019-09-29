<div id="InputLabel" >
  <label for='textAreaField'></label><textarea id='textAreaField' style='position: relative; width: 95%; border: none; height: 150px; box-shadow: 10px 10px 5px 0px rgba(0,0,0,0.75); border-radius: 5px; outline: none;' placeholder='If you are unable to find what you are looking for, please drop your question here...'></textarea><br>
  <div style="position: absolute; right: 5%;">
    <button  id="saveButton" style="box-shadow: 6px 6px 2px 0px rgba(0,0,0,0.45)" class="circular ui green icon button">
      <i class="icon save outline"></i>
    </button>
    <button id="cancelButton" style="box-shadow: 6px 6px 2px 0px rgba(0,0,0,0.45)" class="circular ui red icon button">
      <i class="icon cut"></i>
    </button>
  </div>
</div>

<script>
  $(function(){
    $("#saveButton").click(function ()
    {
      var text=$("#textAreaField").val();
      text=text.trim();
      if(text.length>0)
      {
        $.ajax({

          url: "/addNewQues",

          data:
            {
              data: text,
            },
          success: function(data)
          {
            if(data==='OK')
            {
              $("#nextDiv").empty();
              $("#searchBar").show();
            }

          }
        });
      }
      else
      {
        alert("So You are adding an empty question, wow!, press the cancel button.")
      }
    });

    $("#cancelButton").click(function () {
      $("#nextDiv").empty();
      $("#searchBar").show();
    })
  }
  )
</script>
