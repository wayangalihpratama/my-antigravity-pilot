from app.core.celery_app import celery_app
import time


@celery_app.task(name="process_data_task")
def process_data_task(data: str):
    time.sleep(2)  # Simulate long task
    return f"Processed: {data}"
