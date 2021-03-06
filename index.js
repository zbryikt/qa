// Generated by LiveScript 1.2.0
var x$;
x$ = angular.module('main', []);
x$.factory('skolto', function(){
  return function(des, delay){
    delay == null && (delay = 200);
    return setTimeout(function(){
      var target;
      target = $("#" + des);
      console.log(target);
      return $("html,body").animate({
        scrollTop: target.offset().top
      }, 800);
    }, delay);
  };
});
x$.controller('main', ['$scope', '$http', '$sce', 'skolto'].concat(function($scope, $http, $sce, skolto){
  var param, pid;
  param = window.location.search.replace(/\?/, "").split('&').map(function(it){
    return it.split('=');
  });
  pid = param.filter(function(it){
    return it[0] === 'id';
  }).map(function(it){
    return it[1];
  });
  if (!pid || !pid.length) {
    pid = '10i17hvwS2YX5xMnn1nubEriVBYvB370ftdpmO2mjvOc';
  }
  $scope.show = {
    0: true
  };
  $scope.done = {};
  $scope.goto = function(cur, opt){
    if ($scope.done[cur.id]) {
      return;
    }
    $scope.show[opt.next] = true;
    skolto("section" + opt.next);
    opt.chosen = true;
    return $scope.done[cur.id] = true;
  };
  return $http({
    url: "https://spreadsheets.google.com/feeds/list/" + pid + "/1/public/values?alt=json",
    method: 'GET'
  }).success(function(d){
    return $scope.entries = d.feed.entry.map(function(it, idx){
      var optionCount, i;
      optionCount = parseInt(it['gsx$num'].$t);
      return import$({}, {
        id: idx,
        title: it['gsx$title'].$t,
        desc: $sce.trustAsHtml(markdown.toHTML(it['gsx$description'].$t)),
        options: (function(){
          var i$, to$, results$ = [];
          for (i$ = 1, to$ = optionCount; i$ <= to$; ++i$) {
            i = i$;
            results$.push({
              name: it["gsx$opt" + i].$t,
              next: parseInt(it["gsx$next" + i].$t) - 2
            });
          }
          return results$;
        }()).filter(function(it){
          return it.name;
        })
      });
    });
  });
}));
function import$(obj, src){
  var own = {}.hasOwnProperty;
  for (var key in src) if (own.call(src, key)) obj[key] = src[key];
  return obj;
}