#!/usr/bin/env python
# coding: utf-8

# In[1]:


get_ipython().system('pip install kaggle')


# In[19]:


import sys
print(sys.executable)


# In[ ]:


import kaggle


# In[3]:


get_ipython().system('kaggle datasets download -d ankitbansal06/retail-orders')


# In[3]:


import zipfile
zip_ref=zipfile.ZipFile('retail-orders.zip')
zip_ref.extractall()
zip_ref.close()


# In[4]:


import pandas as pd
df=pd.read_csv('orders.csv',na_values=['Not Available', 'unknown'])
df.head(45)
# reading data and handling null values
#df['Ship Mode'].unique()



# In[5]:


# renaming columns
#df.rename(columns={'Order Id':'order_id','City':'city'})
df.columns=df.columns.str.lower()
df.columns=df.columns.str.replace(' ','_')
df.head()


# In[6]:


df['discount_price']=df['list_price']*df['discount_percent']*0.01
df['sale_price']=df['list_price']-df['discount_price']
df['profit']=df['sale_price']-df['cost_price']
df.head(2)


# In[55]:


# df['order_date'].dtypes
df['order_date']=pd.to_datetime(df['order_date'],format="%Y-%m-%d")
df.dtypes


# In[17]:


# so deleting columns which are not useful
df.drop(columns=['cost_price', 'list_price', 'discount_percent'], inplace=True)
df.head(2)


# In[2]:


pip install psycopg2


# In[20]:


import pandas as pd
from sqlalchemy import create_engine



# PostgreSQL connection
engine = create_engine('postgresql+psycopg2://postgres:razsql@localhost:5432/retail_orders')

# Upload DataFrame to PostgreSQL table
df.to_sql('df_orders', con=engine, index=False, if_exists='append')     # i wont be using replace as it will set constraint to max 




# In[19]:


df.columns

