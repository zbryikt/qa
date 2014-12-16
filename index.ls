angular.module \main, <[]>
  ..factory \skolto, -> (des, delay=100) ->
    <- setTimeout _, delay
    target = $("##des")
    console.log target
    $("html,body").animate({scrollTop: target.offset!top}, 500)

  ..controller \main, <[$scope $http $sce skolto]> ++ ($scope, $http, $sce, skolto) ->
    $scope.show = {0:true}
    $scope.done = {}
    $scope.goto = (cur, next) -> 
      if $scope.done[cur.id] => return
      $scope.show[next] = true
      skolto "section#next"
      $scope.done[cur.id] = true



    $http do
      #url: \https://spreadsheets.google.com/feeds/list/10i17hvwS2YX5xMnn1nubEriVBYvB370ftdpmO2mjvOc/1/public/values?alt=json
      url: \/sample.json
      method: \GET
    .success (d) ->
      $scope.entries = d.feed.entry.map (it, idx) -> 
        option-count = parseInt(it['gsx$num']$t)
        {} <<< do
          id: idx
          title: it['gsx$title']$t
          desc: $sce.trustAsHtml(markdown.toHTML(it['gsx$description']$t))
          options: (for i from 1 to option-count => 
            {name: it["gsx$opt#i"]$t, next: parseInt(it["gsx$next#i"]$t) - 2})filter(->it.name)
