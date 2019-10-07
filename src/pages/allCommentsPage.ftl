<#list comments as str>
<div style="padding-left: 100px;" class="ui relaxed list">
  <div class="item">
    <img class="ui avatar image" src="${str.pp}">
    <div class="content">
      <a class="header">${str.name} <div class="ui red horizontal label">${str.date}</div></a>
      <div class="description"><b>${str.comment}</b></div>
    </div>
  </div>
</div>
</#list>
