class Path {

  var segments;

  Path() {
    segments = new List<Segment>();
  }

  createStartSegment(Point startPosition) {
    var startSegment = new Segment(draw:false);
    startSegment.lines.add(new Line(startPosition, startPosition));
    segments.add(startSegment);
  }

  Segment lastSegment() {
    var result = null;
    if (!segments.isEmpty) {
      result = segments.last;
    }
    return result;
  }

  Segment previousSegment(Segment segment) {
    var result = null;
    if (segment != null) {
      var index = segments.indexOf(segment);
      if (index > 0) {
        result = segments[index - 1];
      }
    }
    return result;
  }

  Line lastLine(Segment segment) {
    var result = null;
    if (segment != null) {
      if (!segment.lines.isEmpty) {
        result = segment.lines.last;
      } else {
        var previous = previousSegment(segment);
        if (previous != null) {
          result = lastLine(previous);
        }
      }
    }
    return result;
  }

}
