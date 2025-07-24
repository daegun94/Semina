import requests
import time
import threading

TARGET_URL = "http://1.1.1.1/login"
REQUESTS_PER_SECOND = 100

def send_request():
    try:
        # 필요 시 payload, headers 등 추가 가능
        response = requests.post(TARGET_URL, timeout=2)
        print(f"[{response.status_code}] {response.text}")
    except requests.RequestException as e:
        print(f"[ERROR] {e}")

def run_load():
    while True:
        threads = []
        for _ in range(REQUESTS_PER_SECOND):
            t = threading.Thread(target=send_request)
            t.start()
            threads.append(t)

        for t in threads:
            t.join()

        time.sleep(1)  # 다음 초까지 대기

if __name__ == "__main__":
    run_load()
