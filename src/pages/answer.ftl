<#list ans as str>
  <div class="ui relaxed list">
    <div class="item">
      <img class="ui avatar image" src="${str.pp}">
      <div class="content">
        <a class="header">${str.author} <div class="ui red horizontal label">${str.date}</div></a>
        <div class="description"><b>${str.name}</b></div>
      </div>
      <a style='color: white; box-shadow: 6px 6px 2px 0px rgba(0,0,0,0.45);' class="ui circular label">${str.like}</a>
      <a style='color: white; box-shadow: 6px 6px 2px 0px rgba(0,0,0,0.45);' class="ui circular label">${str.dislike}</a>
    </div>
  </div>
</#list>
</div>
