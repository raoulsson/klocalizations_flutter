dynamic getValueFromPath(String jsonPath, Map<String, dynamic> jsonObject) {
  var parts = jsonPath.split(".");
  dynamic property = jsonObject;

  for (var part in parts) {
    // Only descend while we still hold a map. If an intermediate segment
    // resolves to a leaf (String/int/List/...) indexing it with the next
    // segment would throw (e.g. "Welcome"["title"]); return null instead so
    // translate() can apply its missing-key fallback.
    if (property is Map) {
      property = property[part];
    } else {
      return null;
    }
  }

  return property;
}

String interpolate(
  String string, {
  Map<String, dynamic> params = const {},
}) {
  var keys = params.keys;
  var result = string;

  for (var key in keys) {
    result = result.replaceAll('{{$key}}', '${params[key]}');
  }

  return result;
}
