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

  static int[] getColorByTemp(double temp, double min, double max) {

    float tempRange = (float)(max - min);

    int minRed = 200;
    int minGreen = 200;
    int minBlue = 200;

    int redRange = 255 - minRed;
    int greenRange = 255 - minGreen;
    int blueRange = 255 - minBlue;

    int red = floor(minRed + redRange * pow(((float)temp - (float)min) / tempRange, 1.5));
    int green = floor(minGreen + greenRange * pow(((float)temp - (float)min) / tempRange, 1.5));
    int blue = floor(minBlue + blueRange * pow(((float)max - (float)temp) / tempRange, 1.5));
    int alpha = 204;

    int[] rgba = { red, green, blue, alpha };
    
    return rgba;
  }
}
