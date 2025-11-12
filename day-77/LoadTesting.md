# 📈 Load Testing with k6 & Locust

## 🧩 Overview

This guide provides setup and usage instructions for performing **load testing** on your APIs or web applications using **k6** (JavaScript-based) and **Locust** (Python-based).

Both tools are open-source and powerful for **performance, stress, and scalability** testing of backend systems.

---

## ⚙️ Prerequisites

Make sure you have the following installed:

| Tool    | Version | Installation                                                                                         |
| ------- | ------- | ---------------------------------------------------------------------------------------------------- |
| Node.js | ≥ 16    | [https://nodejs.org](https://nodejs.org)                                                             |
| Python  | ≥ 3.9   | [https://www.python.org/downloads/](https://www.python.org/downloads/)                               |
| k6      | latest  | [https://k6.io/docs/getting-started/installation/](https://k6.io/docs/getting-started/installation/) |
| Locust  | latest  | `pip install locust`                                                                                 |

---

## 🧪 Load Testing with **k6**

### 1. Project Structure

```
load-testing/
├── k6/
│   ├── test.js
│   └── README.md
└── locust/
    ├── locustfile.py
    └── README.md
```

### 2. Example k6 Test Script (`k6/test.js`)

```javascript
import http from 'k6/http';
import { sleep, check } from 'k6';

export const options = {
  vus: 10, // number of virtual users
  duration: '30s', // total test duration
};

export default function () {
  const res = http.get('https://your-api-endpoint.com/api/status');
  
  check(res, {
    'status is 200': (r) => r.status === 200,
    'response time < 500ms': (r) => r.timings.duration < 500,
  });

  sleep(1);
}
```

### 3. Run the Test

```bash
k6 run k6/test.js
```

### 4. Example Output

```
running (0m30.0s), 10/10 VUs, 300 complete and 0 interrupted iterations
http_reqs................: 300   10.000/s
✓ status is 200..........: 100.00%
✓ response time < 500ms..: 97.33%
```

### 5. Generate Report (optional)

You can output JSON or HTML reports:

```bash
k6 run --out json=results.json k6/test.js
```

Use tools like [k6-reporter](https://github.com/benc-uk/k6-reporter) to visualize results:

```bash
npm install -g k6-reporter
k6 run k6/test.js | k6-reporter --out report.html
```

---

## 🐍 Load Testing with **Locust**

### 1. Example Locust File (`locust/locustfile.py`)

```python
from locust import HttpUser, task, between

class ApiUser(HttpUser):
    wait_time = between(1, 3)

    @task
    def get_status(self):
        self.client.get("/api/status")

    @task
    def post_data(self):
        self.client.post("/api/data", json={"key": "value"})
```

### 2. Run Locust in Web UI Mode

```bash
locust -f locust/locustfile.py --host https://your-api-endpoint.com
```

Then open your browser:
👉 [http://localhost:8089](http://localhost:8089)

### 3. Configure Test in Web UI

* Number of users: `100`
* Spawn rate: `10`
* Host: `https://your-api-endpoint.com`
* Click **Start Swarming**

### 4. Run in CLI Mode

```bash
locust -f locust/locustfile.py --headless -u 100 -r 10 --run-time 1m --host https://your-api-endpoint.com --csv results
```

### 5. Sample Output

```
[2025-11-12 12:00:00] INFO/locust.main: Run time limit set to 1m
Type            Name              # reqs      # fails  Avg  Min  Max  Median  req/s
GET             /api/status        1200        0(0.00%)  150  50  400  160    20.0
POST            /api/data          1200        2(0.17%)  180  60  500  170    20.0
```

---

## 📊 Result Analysis

| Metric            | Description                           |
| ----------------- | ------------------------------------- |
| `RPS (req/s)`     | Requests per second — throughput      |
| `Avg`             | Average response time                 |
| `95th percentile` | Response time under load              |
| `Error %`         | Percentage of failed requests         |
| `VUs / Users`     | Virtual or concurrent users simulated |

---

## 🧰 Best Practices

1. **Start small** – Begin with 10 users, then scale up.
2. **Simulate real behavior** – Use realistic wait times and request mixes.
3. **Use CI/CD Integration** – Run tests on deployments with thresholds.
4. **Monitor backend metrics** – CPU, memory, DB latency alongside load tests.
5. **Set thresholds in k6** to fail builds if performance degrades.

Example threshold:

```javascript
export const options = {
  thresholds: {
    http_req_duration: ['p(95)<500'], // 95% under 500ms
  },
};
```

---

## 📁 References

* [k6 Documentation](https://k6.io/docs/)
* [Locust Documentation](https://docs.locust.io/en/stable/)
* [k6 Cloud](https://app.k6.io/)
* [Locust Distributed Mode](https://docs.locust.io/en/stable/running-distributed.html)


