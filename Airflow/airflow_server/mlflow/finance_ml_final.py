import pandas as pd
import numpy as np
import seaborn as sns

import matplotlib as mpl
import matplotlib.pyplot as plt

# scikit-learn 
from sklearn.compose import ColumnTransformer
from sklearn.datasets import make_moons
from sklearn.impute import SimpleImputer 
from sklearn.linear_model import LogisticRegression, Perceptron
from sklearn.metrics import accuracy_score
from sklearn.model_selection import GridSearchCV, train_test_split
from sklearn.neighbors import KNeighborsClassifier
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import LabelEncoder, OneHotEncoder, StandardScaler
from sklearn.svm import SVC

import mlflow

mlflow.set_tracking_uri("http://localhost:5000")

IS_DEBUG = True
if __name__ == "__main__":
# with mlflow.start_run():
# read data
    df = pd.read_csv("adult.data", header=None, sep=', ', engine='python')
    df_original = pd.read_csv('adult.data', header=None, sep=', ', engine='python')
    columns = ['age', 'workclass', 'fnlwgt', 'education', 'education-num', 'marital-status', 'occupation', 'relationship', 
                'race', 'sex', 'capital-gain', 'capital-loss', 'hours-per-week', 'native-country', 'result']

    df_original.columns = columns

    df = df_original.copy()

    print(df.shape)
    print(df.isnull().sum())

    #gender를 0,1로 인코딩
    gender = LabelEncoder()
    gender.fit(df.sex)

    print(gender.classes_)
    print(gender.transform(['Female', 'Female', 'Male', 'Female', 'Male']))

    # result 칼럼을 label (class) 로써 encoding
    label_le = LabelEncoder()
    df['result'] = label_le.fit_transform(df['result'].values)

    # encode categorical features
    catego_features = ['workclass', 'education', 'marital-status', 'occupation', 
                    'relationship', 'race', 'sex', 'native-country']

    catego_le = LabelEncoder()

    # 카테고리성 칼럼들을 encoding 
    # 카테고리에 '?'도 포함되어 있기 때문에 이 경우 NaN으로 변환
    categories = []
    for i in catego_features:
        df[i] = catego_le.fit_transform(df[i].values)
        classes_list = catego_le.classes_.tolist()
        
        # replace '?' with 'NaN'
        if '?' in classes_list:
            idx = classes_list.index('?')
            df[i] = df[i].replace(idx, np.nan)
        
        # store the total number of values
        categories.append(np.arange(len(classes_list)))

    # print(categories)
    print(df.head(5))

    # 상단에서 정의한 카테고리 칼럼들의 index를 찾아 리스트에 append
    catego_features_idx = []
    for fea in catego_features:
        catego_features_idx.append(df.columns.tolist().index(fea))


    sample_size = 4000
    df_small = df.sample(n = sample_size, random_state = 0)

    X = df_small.drop('result', axis=1).values
    y = df_small['result'].values

    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.2, random_state=0)

    ohe = ColumnTransformer(
        [
            ('ohe', OneHotEncoder(categories = categories, sparse = False), catego_features_idx),
        ],
        remainder = "passthrough"
    )


    # keep only data points without NaN features
    idx = np.isnan(X_train).sum(1) == 0
    X_train = X_train[idx]
    y_train = y_train[idx]
    idx = np.isnan(X_test).sum(1) == 0
    X_test = X_test[idx]
    y_test = y_test[idx]

    from sklearn.neighbors import KNeighborsClassifier
    from sklearn.svm import SVC
    from sklearn.gaussian_process import GaussianProcessClassifier
    from sklearn.tree import DecisionTreeClassifier
    from sklearn.ensemble import RandomForestClassifier
    from sklearn.neural_network import MLPClassifier
    from sklearn.ensemble import AdaBoostClassifier
    from sklearn.naive_bayes import GaussianNB
    from sklearn.discriminant_analysis import QuadraticDiscriminantAnalysis
    from sklearn.gaussian_process.kernels import RBF, DotProduct, Matern,  RationalQuadratic, WhiteKernel

    names = [
        "Nearest Neighbors", #
        "Linear SVM", #
        "RBF SVM",#
        "Gaussian Process",#
        "Decision Tree",#
        "Random Forest",#
        # "Neural Net",
        "AdaBoost",
        "Naive Bayes",
        "QDA",
    ]

    classifiers = [
        KNeighborsClassifier(3),
        SVC(kernel="linear", C=0.025),
        SVC(gamma=2, C=1),
        GaussianProcessClassifier(1.0 * RBF(1.0)),
        DecisionTreeClassifier(max_depth=5),
        RandomForestClassifier(max_depth=5, n_estimators=10, max_features=1),
        # MLPClassifier(alpha=1, max_iter=1000),
        AdaBoostClassifier(),
        GaussianNB(),
        QuadraticDiscriminantAnalysis(),
    ]

    pipelines = [
        Pipeline([('ohe', ohe), ('scl', StandardScaler()), ('clf', KNeighborsClassifier())]),
        Pipeline([('ohe', ohe), ('scl', StandardScaler()), ('clf', SVC())]),
        Pipeline([('ohe', ohe), ('scl', StandardScaler()), ('clf', SVC())]),
        Pipeline([('ohe', ohe), ('scl', StandardScaler()), ('clf', GaussianProcessClassifier())]),
        Pipeline([('ohe', ohe), ('scl', StandardScaler()), ('clf', DecisionTreeClassifier())]),
        Pipeline([('ohe', ohe), ('scl', StandardScaler()), ('clf', RandomForestClassifier())]),
        # Pipeline([('ohe', ohe), ('scl', StandardScaler()), ('clf', MLPClassifier())]),
        Pipeline([('ohe', ohe), ('scl', StandardScaler()), ('clf', AdaBoostClassifier())]),
        Pipeline([('ohe', ohe), ('scl', StandardScaler()), ('clf', GaussianNB())]),
        Pipeline([('ohe', ohe), ('scl', StandardScaler()), ('clf', QuadraticDiscriminantAnalysis())]),
    ]

    param_grids = [
        {'clf__n_neighbors' : [5, 10, 20], 'clf__weights' : ['uniform', 'distance'], 'clf__metric' : ['euclidean', 'manhattan', 'minkowski']}, # knn
        {'clf__kernel': ['linear'], 'clf__C': [1, 10, 100, 1000]}, # svm linear
        {'clf__kernel': ['rbf'], 'clf__gamma': [1e-3, 1e-4], 'clf__C': [1, 10, 100, 1000]}, # svm kernel
        {'clf__kernel': [1*RBF(), 1*DotProduct(), 1*Matern(),  1*RationalQuadratic(), 1*WhiteKernel()]}, # gaussian process classifier
        {'clf__criterion':['gini','entropy'],'clf__max_depth':[4,5,6,7,8,9,10,11,12,15,20,30,40,50,70,90,120,150]}, # decision tree
        {'clf__n_estimators' : [10, 100], 'clf__max_depth' : [6, 8, 10, 12], 'clf__min_samples_leaf' : [8, 12, 18], 'clf__min_samples_split' : [8, 16, 20]}, # random forest
        # {'clf__hidden_layer_sizes': [i for i in range(4,25)], 'clf__activation': ['tanh'],
        #         'clf__solver': ['adam'],
        #         'clf__learning_rate': ['constant'],
        #         'clf__learning_rate_init': [0.001],
        #         'clf__power_t': [0.5],
        #         'clf__alpha': [0.0001],
        #         'clf__max_iter': [10000],
        #         'clf__early_stopping': [False],
        #         'clf__warm_start': [False]}, # MLP (neural net)
        {'clf__n_estimators':[10,50,250,1000], 'clf__learning_rate':[0.01,0.1]}, # AdaBoost
        {'clf__var_smoothing': np.logspace(0,-9, num=100)}, # GaussianNB
        {'clf__reg_param': [0.1, 0.2, 0.3, 0.4, 0.5]} # QuadraticDiscriminantAnalysis (QDA)
        
    ]

    best_score = 0
    best_model = None
    best_pipeline = None
    best_estimator = None
    best_param = None

    # iterate over classifiers
    with mlflow.start_run() as run:
        for name, pipeline, param_grid in zip(names, pipelines, param_grids):
            # set pipe_svm as the estimator
            gs = GridSearchCV(
                estimator = pipeline, 
                param_grid = param_grid, 
                scoring = "accuracy",
                cv = 3,
                n_jobs=4
            )

            gs = gs.fit(X_train, y_train)
            print('[%s: grid search]' % name)
            print('Validation accuracy: %.3f' % gs.best_score_)
            print(gs.best_params_)
            print('\n')



            if gs.best_score_ > best_score:
                best_model = name
                best_pipeline = pipeline
                best_estimator = gs.best_estimator_
                best_score = gs.best_score_
                best_param = gs.best_params_
            mlflow.log_param(name + "_param",gs.best_params_)
            mlflow.log_metric(name + "_score", gs.best_score_)
            mlflow.sklearn.log_model(gs.estimator,"model", registered_model_name=name)
            

    print('The final model selected: [%s]' % best_model)
    print('with parameters', gs.best_params_)
    print('Validation accuracy: %.3f' % best_score)
    print('\n')



    best_estimator.fit(X_test, y_test)
    # print('Test accuracy: %.3f' %clf.score(X_test, y_test))

# mlflow.end_run()