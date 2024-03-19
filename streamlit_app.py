#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd
import numpy as np
import streamlit as st 
from sqlalchemy import create_engine
import joblib
import pickle


# In[3]:



# In[4]:


# Load model and preprocessing objects
model = pickle.load(open('stacking2.pkl', 'rb'))
impute = joblib.load('impute')
winzor = joblib.load('winzor')
scale = joblib.load('standard')
pca = joblib.load('pca')


# In[5]:


def vehicle_prediction(Engine_rpm, Lub_oil_pressure, Fuel_pressure, Coolant_pressure, lub_oil_temp, Coolant_temp):
    # Convert input values to appropriate types and create a DataFrame
    data = {
        "Engine_rpm": [Engine_rpm],
        "Lub_oil_pressure": [Lub_oil_pressure],
        "Fuel_pressure": [Fuel_pressure],
        "Coolant_pressure": [Coolant_pressure],
        "lub_oil_temp": [lub_oil_temp],
        "Coolant_temp": [Coolant_temp]
    }
    df = pd.DataFrame(data)
    
    # Preprocess the input data
    a_imputed = pd.DataFrame(impute.transform(df), columns=df.columns)
    a_winzor = pd.DataFrame(winzor.transform(a_imputed), columns=a_imputed.columns)
    a_scaled = pd.DataFrame(scale.transform(a_winzor), columns=a_winzor.columns)
    a_pca = pd.DataFrame(pca.transform(a_scaled))
    new_column_names = [f"PC{i}" for i in range(1, 6)]
    a_pca.columns = new_column_names
    
    # Predict using the model
    prediction = model.predict(a_pca)
    
    # Return the prediction
    return prediction


# In[6]:


def validate_input(column_name, value, min_value, max_value):
    if value is None:
        return True  # No need for validation if value is None
    
    if value < min_value or value > max_value:
        st.error(f"Invalid input for {column_name}: Value should be between {min_value} and {max_value}")
        return False
    return True


# In[7]:


def predict(data, user, pw, db):
    engine = create_engine(f"mysql+pymysql://{user}:{pw}@localhost/{db}")
    clean = pd.DataFrame(impute.transform(data),columns=data.columns)
    clean1 = pd.DataFrame(winzor.transform(clean),columns=clean.columns)
    clean2 = pd.DataFrame(scale.transform(clean1),columns=clean1.columns)
    clean3 = pd.DataFrame(pca.transform(clean2))
    prediction = pd.DataFrame(model.predict(clean3), columns=['Prediction'])
    prediction['Prediction'] = prediction['Prediction'].map({0: 'NO BREAKDOWN', 1: 'BREAKDOWN'})
    
    final = pd.concat([data, prediction], axis=1)
    final.to_sql('vehicle_predictions', con=engine, if_exists='replace', index=False)
    
    return final


# In[8]:


def main():
    st.title("Vehicle Breakdown Prediction")

    # Sidebar for manual input
    st.sidebar.title("Manual Input")
    Engine_rpm = st.sidebar.number_input("Engine_rpm (Range 61 to 2239)", step=1, value=None)
    Lub_oil_pressure = st.sidebar.number_input("Lub_oil_pressure (Range 0.003 to 7.265)", step=0.1, value=None)
    Fuel_pressure = st.sidebar.number_input("Fuel_pressure (Range 0.003 to 21.138)", step=0.1, value=None)
    Coolant_pressure = st.sidebar.number_input("Coolant_pressure (Range 0.002 to 7.478)", step=0.1, value=None)
    lub_oil_temp = st.sidebar.number_input("lub_oil_temp (Range 71.321 to 89.580)", step=0.1, value=None)
    Coolant_temp = st.sidebar.number_input("Coolant_temp (Range 61.673 to 195.527)", step=0.1, value=None)
    
    valid_inputs = True
    
    # Validate input values
    valid_inputs &= validate_input("Engine_rpm", Engine_rpm, 61, 2239)
    valid_inputs &= validate_input("Lub_oil_pressure", Lub_oil_pressure, 0.003, 7.265)
    valid_inputs &= validate_input("Fuel_pressure", Fuel_pressure, 0.003, 21.138)
    valid_inputs &= validate_input("Coolant_pressure", Coolant_pressure, 0.002, 7.478)
    valid_inputs &= validate_input("lub_oil_temp", lub_oil_temp, 71.321, 89.580)
    valid_inputs &= validate_input("Coolant_temp", Coolant_temp, 61.673, 195.527)

    # Sidebar for file upload
    st.sidebar.title("File Upload")
    uploaded_file = st.sidebar.file_uploader("Choose a file", type=['csv', 'xlsx'], accept_multiple_files=False, key="fileUploader")
    if uploaded_file is not None:
        try:
            data = pd.read_csv(uploaded_file)
        except:
            try:
                data = pd.read_excel(uploaded_file)
            except:
                data = pd.DataFrame(uploaded_file)
    else:
        st.sidebar.warning("You need to upload a CSV or Excel file.")

    # Sidebar for database credentials
    st.sidebar.title("Database Credentials")
    user = st.sidebar.text_input("User", "")
    pw = st.sidebar.text_input("Password", "", type="password")
    db = st.sidebar.text_input("Database", "")

    if st.sidebar.button("Predict From File"):
        if uploaded_file is not None:
            result = predict(data, user, pw, db)
            st.success("Prediction completed and saved to database.")
            st.table(result)
        else:
            st.error("Please upload a file first.")
    
    if st.sidebar.button("Predict From Manual Input"):
        if valid_inputs:
            if st.button("Predict"):
                prediction = vehicle_prediction(Engine_rpm, Lub_oil_pressure, Fuel_pressure, Coolant_pressure, lub_oil_temp, Coolant_temp)
                prediction_label = "NO BREAKDOWN" if result[0] == 0 else "BREAKDOWN"
                st.success(f"The Prediction For Vehicle Condition: {prediction_label}")
                
            if  None not in [Engine_rpm, Lub_oil_pressure, Fuel_pressure, Coolant_pressure, lub_oil_temp, Coolant_temp]:
                    prediction = vehicle_prediction(Engine_rpm, Lub_oil_pressure, Fuel_pressure, Coolant_pressure, lub_oil_temp, Coolant_temp)
                    prediction_label = "NO BREAKDOWN" if prediction[0] == 0 else "BREAKDOWN"
                    st.success(f"The Prediction For Vehicle Condition: {prediction_label}")
          
            else:
                    st.error("Please fill in all the fields.")
                    
        
        else:
             st.error("Please correct the input values before making Predictions.")


# In[9]:


if __name__ == '__main__':
    main()


# In[ ]:



