#!/bin/bash

# Install dependencies
pip install -r requirements.txt

# Run the Streamlit app
streamlit run app/main.py --server.port=8501 --server.address=0.0.0.0
