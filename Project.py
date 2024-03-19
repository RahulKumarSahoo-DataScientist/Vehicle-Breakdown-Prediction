# Problem Statement

"""Unexpected vehicle breakdowns are causing significant financial losses and operational disruptions,
 affecting transportation schedules and increasing maintenance costs. """

# `CRISP-ML(Q)` process model describes six phases:
# 
# 1. Business and Data Understanding
# 2. Data Preparation
# 3. Model Building
# 4. Evaluation
# 5. Deployment
# 6. Monitoring and Maintenance
"""

# Objective(s): : Minimize Unexpected vehicle breakdowns
# Constraints: Minimize Expenses


Success Criteria

Business Success Criteria: Reduce the Unexpected failure of vehicles by at least 30%.
Machine Learning Success Criteria: Build a machine learning model with 95% accuracy
                                   in predicting potential vehicle breakdown.
Economic Success Criteria: Achieve a cost saving of total $2M per year due to the reduction 
                          of unexpected breakdowns
                          
Data Collection

Data: 
#    The Vehicles components details are obtained from Kaggle for people to access.

# Data Dictionary:
# - Dataset contains 19535 Observations
# - 7 features are recorded for each Vehicle
# 
# Description:
    
Engine rpm: This feature represents the rotational speed of the engine's crankshaft,
            measured in revolutions per minute (rpm). The unit is rpm.

Lub oil pressure: Lubricating oil pressure refers to the pressure of the oil circulating within the engine 
                  to lubricate moving parts. It is typically measured in units of pressure, 
                  such as pounds per square inch (psi).

Fuel pressure: Fuel pressure is the pressure at which fuel is delivered to the engine's fuel injectors. 
              It is typically measured in units of pressure, such as pounds per square inch (psi).

Coolant pressure: Coolant pressure refers to the pressure of the engine coolant circulating through 
                  the cooling system. It is typically measured in units of pressure, 
                  such as pounds per square inch (psi).

Lub oil temp: Lubricating oil temperature is the temperature of the engine oil.
              It is typically measured in units of temperature, such as degrees Celsius (°C) 

Coolant temp: Coolant temperature is the temperature of the engine coolant.
              It is typically measured in units of temperature, such as degrees Celsius (°C) 

Vehicle Condition (Target Variable): This feature represents the condition of the engine
                  and is typically a binary variable. For example, 0 indicate a healthy vehicle condition,
                  while 1 indicate a potential issue or malfunction.       
                            
"""


import numpy as np
import pandas as pd

import dtale
import sweetviz

import matplotlib.pyplot as plt
import seaborn as sns

from feature_engine.outliers import Winsorizer
from sklearn.preprocessing import LabelEncoder

from sqlalchemy import create_engine

con = create_engine("mysql+pymysql://{user}:{pw}@localhost/{db}".format(user="root", pw = 1999, db = "Project"))

sql = "select * from New_Vehicle_Data;"

df = pd.read_sql_query(sql, con)

# Data types
df.info()

# EXPLORATORY DATA ANALYSIS (EDA) / DESCRIPTIVE STATISTICS
# ***Descriptive Statistics and Data Distribution Function***

desc= df.describe()

# Calculate the mode for each column

mode_values = df.mode().iloc[0,:6]
mode_values = mode_values.rename("modevalue")

# check is there are any null values 

df.isnull().sum()

# check is there are any duplicate entry

df.duplicated().sum()

sweetviz = sweetviz.analyze([df, "EDA"])
sweetviz.show_html("EDA Report New data.html")

dtale = dtale.show(df)
dtale.open_browser()


sns.pairplot(df, hue='Vehicle_condition', diag_kind='kde',palette='husl')
plt.show()

# Calculate the correlation between input variables

continuous_columns = df.select_dtypes(include=['float64', 'int64']).columns

# Calculate the correlation matrix
correlation_matrix_1= df[continuous_columns].corr()

# Calculate the correlation between input variables and the output variable

# Encode target variable using LabelEncoder
label_encoder = LabelEncoder()
df["Vehicle_condition"] = label_encoder.fit_transform(df["Vehicle_condition"])


correlation_matrix = df.corrwith(df["Vehicle_condition"], axis=0)

correlation_matrix_2 = correlation_matrix.rename("CORR WITH OUTPUT")

# for Visualization Scatter plot of Input Variable vs Output Variable


for column in df.columns:
    if column != 'Vehicle_condition':  # Exclude the output variable
        sns.scatterplot(x=df[column], y=df['Vehicle_condition'], marker='o')
        plt.title('Scatter plot of Input Variable vs Output Variable')
        plt.xlabel(column)
        plt.ylabel('Output Variable')
        plt.show()


sns.pairplot(df[continuous_columns])
plt.suptitle('Pairwise Relationships between Continuous Input Variables', y=1.02)
plt.show()




for column in df.columns:
    sns.histplot(data=df, x=df[column], kde=False)
    plt.title(f'Boxplot of {column} ')
    plt.xlabel(column)
    plt.ylabel('Frequency')
    plt.show()
    


for i in range(len(continuous_columns)):
    for j in range(i+1, len(continuous_columns)):
        sns.scatterplot(data=df, x=continuous_columns[i], y=continuous_columns[j])
        plt.title(f'Scatter Plot of {continuous_columns[i]} vs {continuous_columns[j]}')
        plt.xlabel(continuous_columns[i])
        plt.ylabel(continuous_columns[j])
        plt.show()

# Assuming 'column' is the name of the column you want to visualize


help(sns.boxplot)

for column in df.columns:
    sns.boxplot(data=df[column])
    plt.title(f'Boxplot of {column} ')
    plt.ylabel('Value')
    plt.xlabel(column)
    plt.show()

