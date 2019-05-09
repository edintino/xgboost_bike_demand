# Top 10% solution for [Bike Sharing Demand kaggle challange](https://www.kaggle.com/c/bike-sharing-demand) with [xgboost](https://xgboost.readthedocs.io/en/latest/)

After we look at the dataset we can see that we have a datetime column, which we are going to separate to individual columns, such as year, month, day, hour. Furthermore to not leak solutions we get rid of the casual and registered columns. Lastly when we look at the count(=lettings) histogram we can see that it is a skewed distribution, thus we might look for a transformation to bring it closer to the normal distribution.

| Skew distribution | Log transformed distribution |
|-------------------|------------------------------|
| ![](lettings.png "Skew distribution") | ![](log_lettings.png "Log transformed distribution") |

I used grid search to tune the L1 and L2 regularization of the xgboost using 5-fold cross-validation.

To imrpove the predictions of the model as we do know that the counts are integers we round up to integers our regression predictions. This approach results in 0.41 root mean squared logarithmic error putting in the top 10%.
