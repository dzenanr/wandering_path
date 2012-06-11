class Pen {

  var path;

  Pen(Point startPosition) {
    path = new Path();
    var startSegment = new Segment(draw:false);
    startSegment.lines.add(new Line(startPosition, startPosition));
    path.segments.add(startSegment);
  }

}
