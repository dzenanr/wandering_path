part of wandering_path;

class Segment {

  bool draw;

  var lines;

  Segment({this.draw: true}) {
    lines = new List<Line>();
  }

  Line last() {
    var result = null;
    if (!lines.isEmpty) {
      result = lines.last;
    }
    return result;
  }

}
