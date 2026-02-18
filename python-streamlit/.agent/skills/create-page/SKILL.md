---
name: create-page
description: Guide to adding new Streamlit pages and components.
---

# Create Page Skill

## Overview

This skill guides you through adding new pages and components to the Streamlit application.

## Steps

### 1. Create a New Page

Streamlit handles multi-page apps automatically if you place scripts in a `pages/` directory.

1.  Create `app/pages/` if it doesn't exist.
2.  Create a new Python file in `app/pages/`, e.g., `app/pages/01_Analysis.py`.
    -   Prefixing with numbers (e.g., `01_`, `02_`) controls the order in the sidebar.

```python
import streamlit as st

st.set_page_config(page_title="Analysis", page_icon="📈")

st.markdown("# Analysis Page")
st.sidebar.header("Analysis")
st.write("This is a new page.")
```

### 2. Create Reusable Components

If you have UI logic that is reused, place it in `app/components/`.

1.  Create `app/components/` if it doesn't exist.
2.  Create a module, e.g., `app/components/charts.py`.

```python
import streamlit as st
import pandas as pd
import numpy as np

def plot_chart(data):
    st.line_chart(data)
```

3.  Import and use it in your pages:

```python
from components.charts import plot_chart
# ...
plot_chart(df)
```

### 3. Verify

1.  Run the app: `./dc.sh exec streamlit run app/main.py` (or check the running instance).
2.  Navigate to the new page via the sidebar.
