static class Utils {
  static double distanceTo(PVector u, PVector v) {
    return dist(u.x, u.y, v.x, v.y);
  }

  static int[] extractColor(JSONArray jsonArr) {
    int arr[] = new int[jsonArr.size()];

    for (int i = 0; i < jsonArr.size(); ++i) {
      arr[i] =jsonArr.getInt(i);
    }

    return arr;
  }
}
