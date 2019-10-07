<#list ans as str>
  <div class="ui relaxed list">
    <div class="item">
      <img class="ui avatar image" src="${str.pp}">
      <div class="content">
        <a class="header">${str.author} <div class="ui red horizontal label">${str.date}</div></a>
        <div class="description"><b>${str.name}</b></div>
      </div>
      <a onclick="editComment(${str.ID})" style='box-shadow: 6px 6px 2px 0px rgba(0,0,0,0.45);' class="ui circular label"><i class="paint brush icon"></i></a>
      <a id="showComments${str.ID}" onclick="showCommentsAction(${str.ID})" style='box-shadow: 6px 6px 2px 0px rgba(0,0,0,0.45);' class="ui circular label"><i class="comment outline icon "></i>${str.comCount}</a>
      <div id="ystar.${str.ID}" style="padding-left: 50px" class="ui star rating" data-rating="2"></div>
      <a id="numLike${str.ID}" style='box-shadow: 6px 6px 2px 0px rgba(0,0,0,0.45);' class="ui circular label"><i class="heart icon"></i>${str.like}</a>
      <a id="numDislike${str.ID}" style='box-shadow: 6px 6px 2px 0px rgba(0,0,0,0.45);' class="ui circular label"><i class="thumbs down outline icon"></i>${str.dislike}</a>
      <div id="bstar.${str.ID}"  class="ui rating" data-rating="2"></div>
    </div>
  </div>
  <div id="comments${str.ID}">
  </div>
</#list>
