var _metrix_ai$elm_slider$Native_Events = function () {
  function elementClientPosition ( element ) {
    var clientRect = element.getBoundingClientRect();
    return {x: clientRect.left, y: clientRect.top};
  }
  function eventRelativePosition ( event ) {
    var targetClientRect = event.target.getBoundingClientRect();
    var x = event.clientX - targetClientRect.left;
    var y = event.clientY - targetClientRect.top;
    return {x: Math.round(x), y: Math.round(y)};
  }
  return {
    elementClientPosition: elementClientPosition,
    eventRelativePosition: eventRelativePosition
  };
}();
