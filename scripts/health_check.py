## Health Check Script
# This script checks the health of a service by making an HTTP GET request to a specified URL
# and logs the result. It can be run with a custom URL or defaults to a local service.


import requests
import logging
import sys
from datetime import datetime
import argparse
import time

# Configuration
parser = argparse.ArgumentParser(description="Health check script")
parser.add_argument('-url', type=str, help='URL to check (overrides default)')
args = parser.parse_args()

SERVICE_URL = args.url if args.url else "http://localhost:5678"
LOG_FILE = "health_check.log"

# Setup logging
logging.basicConfig(filename=LOG_FILE, level=logging.INFO, format='%(asctime)s %(levelname)s: %(message)s')

def check_service(url):
    try:
        response = requests.get(url, timeout=5)
        if response.status_code == 200:
            logging.info(f"Service is healthy: {url}")
            print(f"[OK] Service is healthy: {url}")
        else:
            logging.warning(f"Service unhealthy (status {response.status_code}): {url}")
            print(f"[WARNING] Service unhealthy (status {response.status_code}): {url}")
    except Exception as e:
        logging.error(f"Service not responding: {url} | Error: {e}")
        print(f"[ERROR] Service not responding: {url} | Error: {e}")

def check_service_with_retries(url, retries=60, delay=5):
    for attempt in range(1, retries + 1):
        try:
            response = requests.get(url, timeout=5)
            if 200 <= response.status_code < 400:
                logging.info(f"Service is healthy: {url} (status {response.status_code}) on attempt {attempt}")
                print(f"[OK] Service is healthy: {url} (status {response.status_code}) on attempt {attempt}")
                return True
            else:
                logging.warning(f"Service unhealthy (status {response.status_code}): {url} (attempt {attempt})")
                print(f"[WARNING] Service unhealthy (status {response.status_code}): {url} (attempt {attempt})")
        except Exception as e:
            logging.error(f"Service not responding: {url} | Error: {e} (attempt {attempt})")
            print(f"[ERROR] Service not responding: {url} | Error: {e} (attempt {attempt})")
        time.sleep(delay)
    print(f"[FAIL] Service did not become healthy after {retries} attempts.")
    return False

def main():
    # Ensure URL has scheme
    url = SERVICE_URL
    if not url.startswith("http://") and not url.startswith("https://"):
        url = "http://" + url
    success = check_service_with_retries(url)
    if not success:
        sys.exit(1)

if __name__ == "__main__":
    main()
