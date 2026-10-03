import 'dart:math' as math;
import 'dart:ui' show Rect;

/// A word found by OCR, with its box in the image.
class OcrWord {
  final String text;
  final Rect box;

  const OcrWord(this.text, this.box);
}

/// Clockwise rotation (0, 90, 180 or 270) that turns the photo's text
/// upright, voted by the direction of each OCR line's baseline in degrees:
/// 0 reads left-to-right, -90 bottom-to-top, 90 top-to-bottom.
int uprightRotation(List<double> lineAngles) {
  final votes = <int, int>{};
  for (final angle in lineAngles) {
    final turn = ((-angle / 90).round() * 90) % 360;
    votes[turn] = (votes[turn] ?? 0) + 1;
  }
  if (votes.isEmpty) return 0;
  return votes.entries.reduce((a, b) => b.value > a.value ? b : a).key;
}

/// A run of words on one line with no big gap — one label or one value.
class _Segment {
  final String text;
  final Rect box;

  _Segment(List<OcrWord> words)
    : text = words.map((w) => w.text).join(' '),
      box = words
          .map((w) => w.box)
          .reduce((a, b) => a.expandToInclude(b));
}

/// Splits [words] into runs that are a label and runs that are not, e.g.
/// "Month & Yr.of Mfg TVS RONIN" → [label "Month & Yr.of Mfg", "TVS RONIN"].
/// The longest label starting at each word wins.
List<({List<T> words, bool isLabel})> splitAtLabels<T>(
  List<T> words,
  String Function(T word) textOf,
  bool Function(String text) isLabel,
) {
  const maxLabelWords = 5;
  final runs = <({List<T> words, bool isLabel})>[];
  var other = <T>[];
  var i = 0;
  while (i < words.length) {
    var labelEnd = -1;
    for (var j = math.min(words.length, i + maxLabelWords); j > i; j--) {
      if (isLabel(words.sublist(i, j).map(textOf).join(' '))) {
        labelEnd = j;
        break;
      }
    }
    if (labelEnd < 0) {
      other.add(words[i++]);
      continue;
    }
    if (other.isNotEmpty) runs.add((words: other, isLabel: false));
    other = [];
    runs.add((words: words.sublist(i, labelEnd), isLabel: true));
    i = labelEnd;
  }
  if (other.isNotEmpty) runs.add((words: other, isLabel: false));
  return runs;
}

/// ML Kit joins text from neighbouring columns into one line, sometimes with
/// no visible gap ("Month & Yr.of Mfg TVS RONIN"). Split lines wherever words
/// are far apart, then around any label inside.
List<_Segment> _segments(
  List<List<OcrWord>> lines,
  bool Function(String text) isLabel,
) {
  final runs = <List<OcrWord>>[];
  for (final line in lines) {
    final words = line.where((w) => w.text.trim().isNotEmpty).toList()
      ..sort((a, b) => a.box.left.compareTo(b.box.left));
    if (words.isEmpty) continue;
    final heights = words.map((w) => w.box.height).toList()..sort();
    final gapLimit = heights[heights.length ~/ 2];
    var run = [words.first];
    for (final word in words.skip(1)) {
      if (word.box.left - run.last.box.right > gapLimit) {
        runs.add(run);
        run = [word];
      } else {
        run.add(word);
      }
    }
    runs.add(run);
  }
  return [
    for (final run in runs)
      for (final part in splitAtLabels(run, (w) => w.text, isLabel))
        _Segment(part.words),
  ];
}

/// Rebuilds the text of a card from word positions, as "label\nvalue" pairs.
///
/// RCs print labels in columns with each value directly below its label (or
/// beside it), and OCR's own line order mixes the columns up — so values are
/// matched to labels by position instead. [isLabel] tells label text apart
/// from values. Labels with no value nearby are left out.
String layoutRcText(
  List<List<OcrWord>> lines,
  bool Function(String text) isLabel,
) {
  final segments = _segments(lines, isLabel);
  final labels = segments.where((s) => isLabel(s.text)).toList()
    ..sort((a, b) {
      final row = a.box.top.compareTo(b.box.top);
      return row != 0 ? row : a.box.left.compareTo(b.box.left);
    });
  final values = segments.where((s) => !isLabel(s.text)).toList();

  // Score every label/value pair that could belong together, then match the
  // closest pairs first, so one label can't take another's value.
  final pairs = <(double, _Segment, _Segment)>[];
  for (final label in labels) {
    final l = label.box;
    final h = math.max(l.height, 1.0);
    for (final value in values) {
      final v = value.box;
      double? cost;
      final gapBelow = v.top - l.bottom;
      final sameColumn = (v.left - l.left).abs() <= 2.5 * h ||
          (v.left < l.right && v.right > l.left);
      if (v.center.dy > l.bottom - 0.2 * h &&
          gapBelow <= 1.6 * h &&
          sameColumn) {
        // Directly below the label — the usual card layout.
        cost = gapBelow.abs() + 0.3 * (v.left - l.left).abs();
      } else if ((v.center.dy - l.center.dy).abs() <= 0.6 * h &&
          v.left >= l.right - 0.2 * h &&
          v.left - l.right <= 6 * h) {
        // Beside the label, on the same row.
        cost = 2 * h + (v.left - l.right);
      }
      if (cost != null) pairs.add((cost, label, value));
    }
  }
  pairs.sort((a, b) => a.$1.compareTo(b.$1));
  final valueOf = <_Segment, _Segment>{};
  final taken = <_Segment>{};
  for (final (_, label, value) in pairs) {
    if (valueOf.containsKey(label) || taken.contains(value)) continue;
    valueOf[label] = value;
    taken.add(value);
  }

  final out = StringBuffer();
  for (final label in labels) {
    final value = valueOf[label];
    if (value == null) continue;
    out
      ..writeln(label.text)
      ..writeln(value.text);
  }
  return out.toString();
}
