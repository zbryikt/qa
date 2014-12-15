angular.module \main, <[]>
  ..controller \main, <[$scope $http $sce]> ++ ($scope, $http, $sce) ->
    $scope.show = {0:true}
    $scope.goto = (it) -> 
      $scope.show[it] = true
      console.log it, $scope.show

    $http do
      #url: \https://spreadsheets.google.com/feeds/list/10i17hvwS2YX5xMnn1nubEriVBYvB370ftdpmO2mjvOc/1/public/values?alt=json
      url: \/sample.json
      method: \GET
    .success (d) ->
      $scope.entries = d.feed.entry.map -> 
        option-count = parseInt(it['gsx$num']$t)
        {} <<< do
          title: it['gsx$title']$t
          desc: $sce.trustAsHtml(markdown.toHTML(it['gsx$description']$t))
          options: (for i from 1 to option-count => 
            {name: it["gsx$opt#i"]$t, next: parseInt(it["gsx$next#i"]$t) - 2})filter(->it.name)
