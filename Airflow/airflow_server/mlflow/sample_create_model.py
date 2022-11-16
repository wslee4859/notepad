import mlflow


import mlflow.sklearn
from sklearn.ensemble import RandomForestRegressor

mlflow.set_tracking_uri("http://localhost:5000")
params = {"n_estimators": 3, "random_state": 42}

# Log MLflow entities
with mlflow.start_run() as run:
    rfr = RandomForestRegressor(**params).fit([[0, 1]], [1])
    mlflow.log_params(params)
    mlflow.sklearn.log_model(rfr, artifact_path="sklearn-model")

model_uri = "runs:/{}/sklearn-model".format(run.info.run_id)
mv = mlflow.register_model(model_uri, "RandomForestRegressionModel")
print("Name: {}".format(mv.name))
print("Version: {}".format(mv.version))