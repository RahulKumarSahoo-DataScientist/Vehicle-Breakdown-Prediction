# Vehicle-Breakdown-Prediction

Project Overview and Scope:

The project aims to develop a predictive maintenance system for vehicles, specifically focusing on predicting unexpected breakdowns. 
This system will utilize machine learning techniques to analyze historical data related to vehicle health, performance, and maintenance records to forecast potential failures before they occur. 
By identifying early warning signs of impending breakdowns, the system will enable proactive maintenance measures and reduce operational disruptions and minimize maintenance costs.


Business Problem:
Unexpected vehicle breakdowns are causing significant financial losses and operational disruptions, affecting transportation schedules and increasing maintenance costs.

Solution:
Research has been done to find out different relevant factors and finalizing relevant features which is helpful to find out Vehicle Breakdown Prediction. Supervised Model is built Successfully with high accuracy to predict results. 

Business Objective:
Minimize Unexpected vehicle breakdowns
Maximize Vehicle Reliability
Minimize Operational Disruptions

Constraints:
Minimize Expenses
Maximize Operational Efficiency

Success Criteria:

Business Success Criteria:
Reduce the Unexpected failure of vehicles by at least 30%.

Machine Learning Success Criteria:
 Build a machine learning model with 95% accuracy in predicting potential vehicle breakdown.

Economic Success Criteria: 
Achieve a cost saving of total $2M per year due to the reduction of unexpected
breakdowns.

Data Dictionary: 
- Dataset contains 19535 Observations
- 7 features are recorded for each Vehicle

Features:

Engine RPM (Revolutions per minute): This feature represents the rotational speed of the Engine, measured in revolutions per minute (RPM).

Lub Oil Pressure (PSI): Lubricating oil pressure refers to the pressure of the oil circulating within the engine to lubricate moving parts. It is typically measured in units of pressure, such as pounds per square inch (PSI) and 1 PSI is approximately equal to 6895 Pascals.

Fuel Pressure (PSI): Fuel pressure is the pressure at which fuel is delivered to the engine's fuel injectors. It is typically measured in units of pressure, such as pounds per square inch (PSI).

Coolant Pressure (PSI): Coolant pressure refers to the pressure of the engine coolant circulating through the cooling system. It is typically measured in units of pressure, such as pounds per square inch (PSI).

Lub Oil Temp (°C): Lubricating oil temperature is the temperature of the engine oil. It is typically measured in units of temperature, 
      such as degrees Celsius (°C).

Coolant Temp (°C): Coolant temperature is the temperature of the engine coolant. It is typically measured in units of temperature, such as degrees Celsius (°C).

Engine Condition (Binary): This Target Feature represents the condition of the engine and is typically a binary variable.
      For example, “0” indicate a healthy engine condition, while 1 indicate a Potential issue or Malfunction.

Packages Used:

pandas (version 1.3.3)
numpy (version 1.21.2)
scikit-learn (version 0.24.2)
matplotlib (version 3.4.3)
seaborn (version 0.11.2)
scikit-learn (version 0.24.2)
tensorflow (version 2.7.0)
keras (version 2.7.0)
streamlit (version 1.0.0)
sqlalchemy (version 1.4.25)
pymysql (version 1.0.2)
joblib (version 1.1.0)

EDA:
Examine the data distribution
Handling missing values of the dataset
Handling the Outliers
Removing duplicate data
Encoding the categorical variables
Normalizing and Scaling

Not found a single null value from all Features
Not found any duplicate observation from Dataset.
All Features contains Continuous data except the Target Feature.
Target column contains 2 class Binary data.

Data Preprocessing:

Perform “Mean Imputation” for Continuous Data and “Mode Imputation”  for Categorical Data to deal with Missing Values.

Perform “Gaussian Winsorizer” method to deal with Outliers in data.

Perform StandardScaler to scale features to have  mean  0 and  standard deviation 1.

Apply “BOX-COX Transformation” for each Features to stabilize the variance and make the data more normally distributed.

Perform “Principal Component Analysis (PCA)” to reduce the number of features in a dataset while preserving the most amount of important information.

Perform Train-test split  technique to partitioning the data for training and testing purpose.  The training set is used to train the model on the data, while the test set is used to evaluate the model to see how well the model generalizes to unseen data.

Model Building:
Perform more than 10 models and 5 AutoMl Models:

Best Model  – Support Vector Classifier

SVC uses a technique called as "kernel trick" to transform the input data into a higher-dimensional space where it’s create a hyperplane between different classes. kernel trick allows SVC to find a non-linear decision boundary in the higher-dimensional space, making it easier to separate. Common kernel functions include linear, polynomial, and radial basis function (RBF) kernels.

SVC identifies the data points that are closest to the decision boundary (margin) W.R.T  different classes. These support vectors play a crucial role in defining the decision boundary.

SVC aims to maximize the decision boundary while minimizing classification errors. This optimization process is guided by the regularization parameter “C and gamma” which balances the trade-off between maximizing the margin and minimizing errors.

The SVC model learns the optimal decision boundary (hyperplane) that separates each features data point into different classes. It iteratively adjusts the parameters to minimize the classification error and maximize the margin.

Once trained, the SVC model can make predictions on new, unseen data points by classifying them based on their features. It assigns each data point to one of the predefined classes based on its position relative to the decision boundary.

Model  Evaluation:

So, to build and deploy a generalized model we required to Evaluate the model on different metrics, which help us to better optimize the performances, fine-tune it, and obtain a better result.

We used Accuracy, F1-Score, Recall, Precision and Confusion Metrix to Evaluate the model Performance.  

Model Deployment - Strategy
Streamlit :

It is an open source Python Library. It enables developers to quickly build highly interactive web applications around their data, Machine learning models, and pretty much anything.

Challenges:

No Real Data is provided
Difficult to get data for Automobile industries 
Imbalanced Data
Regular Routine checkups
Lack of Servicing

Future Scopes:

Integration with IoT Devices
Predictive Analytics for Engine Parts Inventory
Servicing the vehicle in time according to the needs 
These Prediction allows user to allocate resources effectively for future growth 












