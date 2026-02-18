---
trigger: always_on
description: Best practices for developing Streamlit applications in this stack.
---

## Streamlit Best Practices

### Code Organization

-   **Modularize Code**: Separate UI logic from data processing and business logic.
-   **Component Reusability**: Extract reusable UI components into functions in a `components/` directory or module.
-   **Configuration**: Use `st.secrets` for sensitive data and `.env` for environment variables.

### Performance & Caching

1.  **Use `st.cache_data`**:
    -   Cache data loading and expensive computations.
    -   Example:
        ```python
        @st.cache_data
        def load_data(url):
            return pd.read_csv(url)
        ```

2.  **Use `st.cache_resource`**:
    -   Cache global resources like database connections or ML models.
    -   Example:
        ```python
        @st.cache_resource
        def init_connection():
            return create_engine("postgresql://...")
        ```

### State Management

-   **Session State**: Use `st.session_state` to persist data across reruns.
-   **Callbacks**: Use `on_change` or `on_click` callbacks to update state before the script reruns.
    ```python
    def update_counter():
        st.session_state.count += 1

    st.button("Increment", on_click=update_counter)
    ```

### UI/UX

-   **Layout**: Use `st.columns`, `st.tabs`, and `st.expander` to organize content.
-   **Feedback**: Use `st.spinner`, `st.progress`, or `st.toast` to provide feedback for long-running operations.

### Testing & Linting

-   **Linting**: Use `flake8` to enforce code style.
-   **Formatting**: Use `black` to format code.
-   **Unit Tests**: Write unit tests for your business logic functions using `pytest`.

### Related Rules
- Docker Commands @docker-commands.md
