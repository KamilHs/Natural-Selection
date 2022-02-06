class FleshConfig {
  int count;
  int[] c;
  int interval;
  float energy;
  int radius;

  FleshConfig(JSONObject config) {
    count = config.getInt("count");
    radius = config.getInt("radius");
    interval = config.getInt("interval");
    energy = config.getFloat("energy");

    JSONArray cJson = config.getJSONArray("color");
    c = new int[cJson.size()];

    for (int i = 0; i < cJson.size(); ++i) {
      c[i] = cJson.getInt(i);
    }
  }
}

class BacteriaConfig {
  int[] c;
  int width;
  int height;
  int maxAge;
  double probOfAmoeba;
  HashMap<String, Double> energy = new HashMap<String, Double>();
  HashMap<String, Double> speed = new HashMap<String, Double>();
  HashMap<String, Double> coldTolerance = new HashMap<String, Double>();
  HashMap<String, Double> heatTolerance = new HashMap<String, Double>();

  BacteriaConfig(JSONObject config) {
    width = config.getInt("width");
    height = config.getInt("height");
    maxAge = config.getInt("maxAge");
    probOfAmoeba = config.getDouble("probOfAmoeba");
    JSONObject energyJson = config.getJSONObject("energy");
    JSONObject speedJson = config.getJSONObject("speed");
    JSONObject coldToleranceJson = config.getJSONObject("coldTolerance");
    JSONObject heatToleranceJson = config.getJSONObject("heatTolerance");

    energy.put("max", energyJson.getDouble("max"));
    energy.put("initial", energyJson.getDouble("initial"));
    energy.put("minForReplicate", energyJson.getDouble("minForReplicate"));
    energy.put("lossAfterReplicate", energyJson.getDouble("lossAfterReplicate"));
    energy.put("lossPerFrame", energyJson.getDouble("lossPerFrame"));

    speed.put("min", speedJson.getDouble("min"));
    speed.put("initial", speedJson.getDouble("initial"));
    speed.put("max", speedJson.getDouble("max"));
    speed.put("epsilon", speedJson.getDouble("epsilon"));
    speed.put("speedEnergyFactor", speedJson.getDouble("speedEnergyFactor"));

    coldTolerance.put("min", coldToleranceJson.getDouble("min"));
    coldTolerance.put("max", coldToleranceJson.getDouble("max"));
    coldTolerance.put("initial", coldToleranceJson.getDouble("initial"));
    coldTolerance.put("epsilon", coldToleranceJson.getDouble("epsilon"));
    coldTolerance.put("coldEnergyFactor", coldToleranceJson.getDouble("coldEnergyFactor"));

    heatTolerance.put("min", heatToleranceJson.getDouble("min"));
    heatTolerance.put("max", heatToleranceJson.getDouble("max"));
    heatTolerance.put("initial", heatToleranceJson.getDouble("initial"));
    heatTolerance.put("epsilon", heatToleranceJson.getDouble("epsilon"));
    heatTolerance.put("heatEnergyFactor", heatToleranceJson.getDouble("heatEnergyFactor"));

    JSONArray cJson = config.getJSONArray("color");
    c = new int[cJson.size()];

    for (int i = 0; i < cJson.size(); ++i) {
      c[i] = cJson.getInt(i);
    }
  }
}

class AmoebaConfig {
  int[] c;
  int width;
  int height;
  int maxAge;
  HashMap<String, Double> energy = new HashMap<String, Double>();
  HashMap<String, Double> speed = new HashMap<String, Double>();
  HashMap<String, Double> coldTolerance = new HashMap<String, Double>();
  HashMap<String, Double> heatTolerance = new HashMap<String, Double>();

  AmoebaConfig(JSONObject config) {
    width = config.getInt("width");
    height = config.getInt("height");
    maxAge = config.getInt("maxAge");
    JSONObject energyJson = config.getJSONObject("energy");
    JSONObject speedJson = config.getJSONObject("speed");
    JSONObject coldToleranceJson = config.getJSONObject("coldTolerance");
    JSONObject heatToleranceJson = config.getJSONObject("heatTolerance");

    energy.put("max", energyJson.getDouble("max"));
    energy.put("initial", energyJson.getDouble("initial"));
    energy.put("minForReplicate", energyJson.getDouble("minForReplicate"));
    energy.put("lossAfterReplicate", energyJson.getDouble("lossAfterReplicate"));
    energy.put("lossPerFrame", energyJson.getDouble("lossPerFrame"));

    speed.put("min", speedJson.getDouble("min"));
    speed.put("initial", speedJson.getDouble("initial"));
    speed.put("max", speedJson.getDouble("max"));
    speed.put("epsilon", speedJson.getDouble("epsilon"));
    speed.put("speedEnergyFactor", speedJson.getDouble("speedEnergyFactor"));

    coldTolerance.put("min", coldToleranceJson.getDouble("min"));
    coldTolerance.put("max", coldToleranceJson.getDouble("max"));
    coldTolerance.put("initial", coldToleranceJson.getDouble("initial"));
    coldTolerance.put("epsilon", coldToleranceJson.getDouble("epsilon"));
    coldTolerance.put("coldEnergyFactor", coldToleranceJson.getDouble("coldEnergyFactor"));

    heatTolerance.put("min", heatToleranceJson.getDouble("min"));
    heatTolerance.put("max", heatToleranceJson.getDouble("max"));
    heatTolerance.put("initial", heatToleranceJson.getDouble("initial"));
    heatTolerance.put("epsilon", heatToleranceJson.getDouble("epsilon"));
    heatTolerance.put("heatEnergyFactor", heatToleranceJson.getDouble("heatEnergyFactor"));

    JSONArray cJson = config.getJSONArray("color");
    c = new int[cJson.size()];

    for (int i = 0; i < cJson.size(); ++i) {
      c[i] = cJson.getInt(i);
    }
  }
}

class SeasonConfig {
  int[] bg;
  double min;
  double max;

  SeasonConfig(JSONObject config) {
    min =  config.getDouble("min");
    max =  config.getDouble("max");

    JSONArray bgJson = config.getJSONArray("bg");
    bg = new int[bgJson.size()];

    for (int i = 0; i < bgJson.size(); ++i) {
      bg[i] = bgJson.getInt(i);
    }
  }
}

enum Season {
    winter,
    spring,
    summer,
    autumn
}

class ClimateConfig {
  double normalTemp;
  double currentTemp;
  Season currentSeason = Season.spring; 
  SeasonConfig winter;
  SeasonConfig summer;

  ClimateConfig(JSONObject config) {
    normalTemp = config.getDouble("normalTemp");
    currentTemp = normalTemp;
    winter = new SeasonConfig(config.getJSONObject("winter"));
    summer = new SeasonConfig(config.getJSONObject("summer"));
  }
}

public class Config {
  FleshConfig flesh;
  BacteriaConfig bacteria;
  AmoebaConfig amoeba;
  ClimateConfig climate;
  boolean showLabels = false;

  Config(String path) {
    JSONObject json = loadJSONObject(path);
    JSONObject fleshConfigJson = json.getJSONObject("flesh");
    JSONObject bacteriaConfigJson = json.getJSONObject("bacteria");
    JSONObject amoebaConfig = json.getJSONObject("amoeba");
    JSONObject climateConfig = json.getJSONObject("climate");

    flesh = new FleshConfig(fleshConfigJson);
    bacteria = new BacteriaConfig(bacteriaConfigJson);
    amoeba = new AmoebaConfig(amoebaConfig);
    climate = new ClimateConfig(climateConfig);
  }
}
