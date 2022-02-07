

static class Climate {
    public static float getRandomNumber(float min, float max) {
        return(float)(Math.random() * (max - min)) + min;
    }
        static void climateChange(Config config) {
            if (config.climate.currentSeason == Season.spring) {
                config.climate.currentSeason = Season.summer;
                config.climate.currentTemp = getRandomNumber((float)config.climate.summer.min,(float)config.climate.summer.max);
            } else if (config.climate.currentSeason == Season.summer) {
                config.climate.currentSeason = Season.autumn;
                config.climate.currentTemp = config.climate.normalTemp;
            } else if (config.climate.currentSeason == Season.autumn) {
                config.climate.currentSeason = Season.winter;
                config.climate.currentTemp = getRandomNumber((float)config.climate.winter.min,(float)config.climate.winter.max);
            } else {
                config.climate.currentSeason = Season.spring;
                config.climate.currentTemp = config.climate.normalTemp;
            }
        }
    }