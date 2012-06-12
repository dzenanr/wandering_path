#import('dart:html');
#source('model/Pen.dart');
#source('model/Path.dart');
#source('model/Segment.dart');
#source('model/Line.dart');

// See the style guide: http://www.dartlang.org/articles/style-guide/ .

// See the basics canvas tutorial:
// http://dev.opera.com/articles/view/html-5-canvas-the-basics/ .
// See the canvas painting tutorial:
// http://dev.opera.com/articles/view/html5-canvas-painting/ .

// For debugging use print() and CTRL+SHIFT+J to open the console in Chrome.

final int LINE_WIDTH = 1;
final String LINE_COLOR = '#000000'; // black
final num PEN_SIZE = 4;
final num MAX_LINE_COUNT_IN_SEGMENT = 8;
// The canvas will be redrawn every INTERVAL ms.
final int INTERVAL = 10;

var canvas;
var context;
var segmentButton;
var pen;

Point center() {
  var x = canvas.width / 2;
  var y = canvas.height / 2;
  return new Point(x, y);
}

num randomNum(num maxNum) {
  return Math.random() * maxNum;
}

clear() {
  context.clearRect(0, 0, canvas.width, canvas.height);
  border();
}

border() {
  context.beginPath();
  context.rect(0, 0, canvas.width, canvas.height);
  context.lineWidth = LINE_WIDTH;
  context.strokeStyle = LINE_COLOR;
  context.stroke();
  context.closePath();
}

draw() {
  clear();
  context.beginPath();
  context.lineWidth = LINE_WIDTH;
  context.strokeStyle = LINE_COLOR;
  try {
    for (Segment segment in pen.path.segments) {
      if (segment.draw) {
        // draw line
        for (Line line in segment.lines) {
          context.moveTo(line.beginPoint.x, line.beginPoint.y);
          context.lineTo(line.endPoint.x, line.endPoint.y);
        }
      }
    }
    var lastLine = pen.path.lastLine(pen.path.lastSegment());
    // draw pen
    if (lastLine != null) {
      context.rect(lastLine.endPoint.x - PEN_SIZE / 2,
        lastLine.endPoint.y  - PEN_SIZE / 2, PEN_SIZE, PEN_SIZE);
    } else {
      context.rect(center().x - PEN_SIZE / 2,
        center().y  - PEN_SIZE / 2, PEN_SIZE, PEN_SIZE);
    }
  } catch(final error) {
    print('Error in wandering.draw()! -- $error');
  }
  context.fill();
  context.stroke();
  context.closePath();
}

main() {
  canvas = document.query('#canvas');
  context = canvas.getContext('2d');
  pen = new Pen(center());
  segmentButton = document.query('#segment');
  segmentButton.on.click.add((MouseEvent e) {
    try {
      var lastLine = pen.path.lastLine(pen.path.lastSegment());
      var segment = new Segment();
      pen.path.segments.add(segment);
      int lineCount = randomNum(MAX_LINE_COUNT_IN_SEGMENT).toInt();
      for (var i = 0; i < lineCount; i++) {
        var x = randomNum(canvas.width - PEN_SIZE / 2);
        var y = randomNum(canvas.height - PEN_SIZE / 2);
        var randomPoint = new Point(x, y);
        var line = new Line(lastLine.endPoint, randomPoint);
        segment.lines.add(line);
        lastLine = line;
      }
    } catch(final error) {
      print('Error in wandering.main()! -- $error');
    }
  });
  // Redraw every INTERVAL ms.
  document.window.setInterval(draw, INTERVAL);
}


