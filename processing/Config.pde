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
    double probOfAmoeba;
    HashMap<String, Double> energy = new HashMap<String, Double>();
    HashMap<String, Double> speed = new HashMap<String, Double>();
    
    BacteriaConfig(JSONObject config) {
        width = config.getInt("width");
        height = config.getInt("height");
        JSONObject energyJson = config.getJSONObject("energy");
        JSONObject speedJson = config.getJSONObject("speed");
        
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
        
        JSONArray cJson = config.getJSONArray("color");
        c = new int[cJson.size()];
        
        for (int i = 0; i < cJson.size(); ++i) {
            c[i] = cJson.getInt(i);
        }
    }
}


public class Config {
    FleshConfig flesh;
    BacteriaConfig bacteria;
    
    Config(String path) {
        JSONObject json = loadJSONObject(path);
        JSONObject fleshConfigJson = json.getJSONObject("flesh");
        JSONObject bacteriaConfigJson = json.getJSONObject("bacteria");
        
        flesh = new FleshConfig(fleshConfigJson);
        bacteria = new BacteriaConfig(bacteriaConfigJson);
    }
}
