angular.module \main, <[]>
  ..factory \skolto, -> (des, delay=200) ->
    <- setTimeout _, delay
    target = $("##des")
    console.log target
    $("html,body").animate({scrollTop: target.offset!top}, 800)

  ..controller \main, <[$scope $http $sce skolto]> ++ ($scope, $http, $sce, skolto) ->
    param = window.location.search.replace /\?/, "" .split \& .map -> it.split \=
    pid = param.filter(-> it.0 == \id ).map -> it.1
    if !pid or !pid.length=> pid = \10i17hvwS2YX5xMnn1nubEriVBYvB370ftdpmO2mjvOc
    $scope.show = {0:true}
    $scope.done = {}
    $scope.goto = (cur, opt) -> 
      if $scope.done[cur.id] => return
      $scope.show[opt.next] = true
      skolto "section#{opt.next}"
      opt.chosen = true
      $scope.done[cur.id] = true



    $http do
      #url: \https://spreadsheets.google.com/feeds/list/10i17hvwS2YX5xMnn1nubEriVBYvB370ftdpmO2mjvOc/1/public/values?alt=json
      url: "https://spreadsheets.google.com/feeds/list/#pid/1/public/values?alt=json"
      #url: \/sample.json
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
