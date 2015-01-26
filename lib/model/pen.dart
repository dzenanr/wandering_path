part of wandering_path;

class Pen {

  var path;

  Pen(Point startPosition) {
    path = new Path();
    path.createStartSegment(startPosition);
  }

}
