library wandering_path;

import 'dart:html';
import 'dart:async';
import 'dart:math';

part 'model/pen.dart';
part 'model/path.dart';
part 'model/segment.dart';
part 'model/line.dart';

// See the style guide: http://www.dartlang.org/articles/style-guide/ .

// See the basics canvas tutorial:
// http://dev.opera.com/articles/view/html-5-canvas-the-basics/ .
// See the canvas painting tutorial:
// http://dev.opera.com/articles/view/html5-canvas-painting/ .

// For debugging use print() and CTRL+SHIFT+J to open the console in Chrome.

final int lineWidth = 1;
final String lineColor = '#000000'; // black
final int penSize = 4;
final int maxLineCountInSegment = 8;
// The canvas will be redrawn every INTERVAL ms.
final int interval = 10;

var canvas;
var context;
var segmentButton;
var pen;

Point center() {
  var x = canvas.width / 2;
  var y = canvas.height / 2;
  return new Point(x, y);
}

int randomInt(int maxInt) {
  Random random = new Random();
  return random.nextInt(maxInt);
}

double randomDouble() {
  Random random = new Random();
  return random.nextDouble();
}

clear() {
  context.clearRect(0, 0, canvas.width, canvas.height);
  border();
}

border() {
  context.beginPath();
  context.rect(0, 0, canvas.width, canvas.height);
  context.lineWidth = lineWidth;
  context.strokeStyle = lineColor;
  context.stroke();
  context.closePath();
}

draw() {
  clear();
  context.beginPath();
  context.lineWidth = lineWidth;
  context.strokeStyle = lineColor;
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
      context.rect(lastLine.endPoint.x - penSize / 2,
        lastLine.endPoint.y  - penSize / 2, penSize, penSize);
    } else {
      context.rect(center().x - penSize / 2,
        center().y  - penSize / 2, penSize, penSize);
    }
  } catch(error) {
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
      int lineCount = randomInt(maxLineCountInSegment);
      for (var i = 0; i < lineCount; i++) {
        var x = randomDouble() * (canvas.width - penSize / 2);
        var y = randomDouble() * (canvas.height - penSize / 2);
        var randomPoint = new Point(x, y);
        var line = new Line(lastLine.endPoint, randomPoint);
        segment.lines.add(line);
        lastLine = line;
      }
    } catch(error) {
      print('Error in wandering.main()! -- $error');
    }
  });
  // Redraw every interval ms.
  new Timer.repeating(interval, (t) => draw());
}


