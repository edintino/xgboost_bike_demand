# Top 10% solution for [Bike Sharing Demand kaggle challange](https://www.kaggle.com/c/bike-sharing-demand) with [xgboost](https://xgboost.readthedocs.io/en/latest/)


## Some feature engineering

After we look at the dataset we can see that we have a datetime column, which we are going to separate to individual columns, such as year, month, day, hour. Furthermore to not leak solutions we get rid of the casual and registered columns. Lastly when we look at the count(=lettings) histogram we can see that it is a skewed, thus we might look for a transformation to bring it closer to the ![normal distribution](https://github.com/eugeniodintino/xgboost_bike_demand/blob/master/log_lettings.pdf).

![skewed](https://github.com/eugeniodintino/xgboost_bike_demand/blob/master/lettings.pdf "a")

