import streamlit as st


st.set_page_config(
    page_title="Hello Streamlit",
    page_icon="👋",
)

st.write("# Welcome to Streamlit! 👋")

st.sidebar.success("Select a demo above.")

st.markdown(
    """
    Streamlit is an open-source app framework built specifically for
    Machine Learning and Data Science projects.
    """
)

if st.button("Say hello"):
    st.write("Why hello there")
else:
    st.write("Goodbye")
