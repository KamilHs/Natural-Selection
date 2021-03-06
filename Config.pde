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
    c = Utils.extractColor(cJson);
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
  HashMap<String, Double> temp = new HashMap<String, Double>();

  BacteriaConfig(JSONObject config) {
    width = config.getInt("width");
    height = config.getInt("height");
    maxAge = config.getInt("maxAge");
    probOfAmoeba = config.getDouble("probOfAmoeba");
    JSONObject energyJson = config.getJSONObject("energy");
    JSONObject speedJson = config.getJSONObject("speed");
    JSONObject tempJson = config.getJSONObject("temp");

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

    temp.put("max", tempJson.getDouble("max"));
    temp.put("min", tempJson.getDouble("min"));
    temp.put("initial", tempJson.getDouble("initial"));
    temp.put("range", tempJson.getDouble("range"));
    temp.put("epsilon", tempJson.getDouble("epsilon"));
    temp.put("tempEnergyFactor", tempJson.getDouble("tempEnergyFactor"));

    JSONArray cJson = config.getJSONArray("color");
    c = Utils.extractColor(cJson);
  }
}

class AmoebaConfig {
  int[] c;
  int width;
  int height;
  int maxAge;
  HashMap<String, Double> energy = new HashMap<String, Double>();
  HashMap<String, Double> speed = new HashMap<String, Double>();
  HashMap<String, Double> temp = new HashMap<String, Double>();

  AmoebaConfig(JSONObject config) {
    width = config.getInt("width");
    height = config.getInt("height");
    maxAge = config.getInt("maxAge");
    JSONObject energyJson = config.getJSONObject("energy");
    JSONObject speedJson = config.getJSONObject("speed");
    JSONObject tempJson = config.getJSONObject("temp");

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

    temp.put("max", tempJson.getDouble("max"));
    temp.put("min", tempJson.getDouble("min"));
    temp.put("initial", tempJson.getDouble("initial"));
    temp.put("range", tempJson.getDouble("range"));
    temp.put("epsilon", tempJson.getDouble("epsilon"));
    temp.put("tempEnergyFactor", tempJson.getDouble("tempEnergyFactor"));

    JSONArray cJson = config.getJSONArray("color");
    c = Utils.extractColor(cJson);
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
    bg = Utils.extractColor(bgJson);
  }
}

enum Season {
  winter,
    spring,
    summer,
    autumn
}

class ClimateConfig {
  double initialTemp;
  double currentTemp;
  int climateDuration;
  Season currentSeason = Season.spring;
  SeasonConfig winter;
  SeasonConfig summer;

  ClimateConfig(JSONObject config) {
    initialTemp = config.getDouble("initialTemp");
    climateDuration = config.getInt("climateDuration");
    currentTemp = initialTemp;
    winter = new SeasonConfig(config.getJSONObject("winter"));
    summer = new SeasonConfig(config.getJSONObject("summer"));
  }
}

class GraphConfig {
  int width;
  int height;
  int x0;
  int y0;
  String label;
  int tick;
  int[] grColor;

  GraphConfig(JSONObject config) {
    width = config.getInt("width");
    height = config.getInt("height");
    x0 = config.getInt("x0");
    y0 = config.getInt("y0");
    tick = config.getInt("tick");
    label = config.getString("label");
    JSONArray colorJson = config.getJSONArray("color");
    grColor = Utils.extractColor(colorJson);
  }
}

public class Config {
  FleshConfig flesh;
  BacteriaConfig bacteria;
  AmoebaConfig amoeba;
  ClimateConfig climate;
  GraphConfig bacteriaPopulation;
  GraphConfig amoebaPopulation;
  GraphConfig bacteriaSpeed;
  GraphConfig amoebaSpeed;
  boolean showLabels = false;

  Config(String path) {
    JSONObject json = loadJSONObject(path);
    JSONObject fleshConfigJson = json.getJSONObject("flesh");
    JSONObject bacteriaConfigJson = json.getJSONObject("bacteria");
    JSONObject amoebaConfig = json.getJSONObject("amoeba");
    JSONObject climateConfig = json.getJSONObject("climate");
    JSONObject bacteriaPopulationGraphConfig = json.getJSONObject("bacteriaPopulationGraph");
    JSONObject amoebaPopulationGraphConfig = json.getJSONObject("amoebaPopulationGraph");
    JSONObject bacteriaSpeedGraphConfig = json.getJSONObject("bacteriaSpeedGraph");
    JSONObject amoebaSpeedGraphConfig = json.getJSONObject("amoebaSpeedGraph");

    flesh = new FleshConfig(fleshConfigJson);
    bacteria = new BacteriaConfig(bacteriaConfigJson);
    amoeba = new AmoebaConfig(amoebaConfig);
    climate = new ClimateConfig(climateConfig);
    bacteriaPopulation = new GraphConfig(bacteriaPopulationGraphConfig);
    amoebaPopulation = new GraphConfig(amoebaPopulationGraphConfig);
    bacteriaSpeed = new GraphConfig(bacteriaSpeedGraphConfig);
    amoebaSpeed = new GraphConfig(amoebaSpeedGraphConfig);
  }
}
