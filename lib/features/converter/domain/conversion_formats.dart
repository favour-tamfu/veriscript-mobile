// File-converter format support. CloudConvert handles far more than the
// original pdf/docx/txt trio, so we expose documents, images, spreadsheets and
// presentations and offer sensible target formats per input.

const List<String> _docFormats = [
  'pdf', 'docx', 'doc', 'odt', 'rtf', 'txt', 'html', 'md', 'epub',
];
const List<String> _imageFormats = [
  'jpg', 'png', 'webp', 'gif', 'bmp', 'tiff', 'heic',
];
const List<String> _sheetFormats = ['xlsx', 'xls', 'csv', 'ods'];
const List<String> _slideFormats = ['pptx', 'ppt', 'odp'];

/// Extensions the file picker accepts as conversion input.
const List<String> kConvertibleInputExtensions = [
  'pdf', 'docx', 'doc', 'odt', 'rtf', 'txt', 'html', 'md', 'epub',
  'jpg', 'jpeg', 'png', 'webp', 'gif', 'bmp', 'tiff', 'heic',
  'xlsx', 'xls', 'csv', 'ods',
  'pptx', 'ppt', 'odp',
];

/// Normalises a file extension to the format name CloudConvert expects.
String normalizeFormat(String ext) {
  final e = ext.toLowerCase();
  if (e == 'jpeg') return 'jpg';
  if (e == 'tif') return 'tiff';
  return e;
}

/// Sensible target formats to offer for a given source format (excludes the
/// source itself). Cross-category conversions that don't make sense (e.g.
/// spreadsheet → image) are not offered; everything can go to PDF.
List<String> targetFormatsFor(String from) {
  final f = normalizeFormat(from);
  final Set<String> targets;
  if (_imageFormats.contains(f)) {
    targets = {..._imageFormats, 'pdf'};
  } else if (_sheetFormats.contains(f)) {
    targets = {..._sheetFormats, 'pdf'};
  } else if (_slideFormats.contains(f)) {
    targets = {..._slideFormats, 'pdf'};
  } else if (f == 'pdf') {
    targets = {'docx', 'txt', 'html', 'rtf', 'odt', 'jpg', 'png'};
  } else {
    targets = {..._docFormats, 'pdf'};
  }
  targets.remove(f);
  return targets.toList()..sort();
}
