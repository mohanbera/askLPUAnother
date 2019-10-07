<div id="commentBar${ID}" style="padding-left: 100px" class="ui relaxed list">
  <div class="item">
    <img class="ui avatar image" src="${pp}">
    <div class="content">
      <a class="header"> ${name} <div class="ui red horizontal label">${today}</div></a>
    </div>
    <div class="ui fluid icon input">
      <textarea id="commentText${ID}" style="position: relative; left:33px; width: 60%; box-shadow: 4px 4px 2px 0px rgba(0,0,0,0.35); border-radius: 5px; outline: none" placeholder="Write your comment here..."></textarea>
      <br>
      <br>
      <div style="position: relative; left: 33px;">
        <button id="commetSave${ID}" onclick="commentSaveAction(${ID})" style="box-shadow: 6px 6px 2px 0px rgba(0,0,0,0.45)" class="circular ui green icon button">
          <i class="icon save outline"></i>
        </button>
        <button id="commentCancel${ID}" onclick="commentCancelAction(${ID})" style="box-shadow: 6px 6px 2px 0px rgba(0,0,0,0.45)" class="circular ui red icon button">
          <i class="icon cut"></i>
        </button>
      </div>
    </div>
  </div>
</div>
