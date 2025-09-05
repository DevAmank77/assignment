# 📱 Request Handling Workflow Prototype 🚀

<p align="center">
<img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter"/>
<img src="https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white" alt="Node.js"/>
<img src="https://img.shields.io/badge/Express.js-000000?style=for-the-badge&logo=express&logoColor=white" alt="Express.js"/>
<img src="https://img.shields.io/badge/Riverpod-4A0091?style=for-the-badge" alt="Riverpod"/>
</p>

A full-stack mobile application prototype simulating a real-world request and confirmation workflow. This project demonstrates a clean, scalable architecture with a **Flutter frontend** and a **Node.js backend**, featuring a robust system for handling **real-time status updates** and **partial request fulfillment**.

---

## ✨ Key Features

* 👤 **Role-Based Authentication** – Differentiate between End User and Receiver.
* 🛒 **Multi-Item Request Creation** – End Users can create requests with multiple items.
* ✅ **Item-by-Item Confirmation** – Receivers can mark each item as *Available* or *Not Available*.
* 📊 **Real-Time Status Tracking** – Clear, live-updating statuses (Pending, Confirmed, Partially Fulfilled).
* 🔁 **Partial Fulfillment & Reassignment** – Automatically creates new requests for unfulfilled items.
* 🔄 **Automatic UI Updates** – Periodic polling ensures the app always reflects the latest request status.

---

## 🛠️ System Design & Architecture

| Component        | Technology                  | Rationale                                     |
| ---------------- | --------------------------- | --------------------------------------------- |
| **Frontend**     | Flutter                     | High-performance, cross-platform UI.          |
| **Architecture** | MVVM (Model-View-ViewModel) | Separation of concerns for maintainable code. |
| **State Mgmt**   | Riverpod                    | Scalable, compile-safe state management.      |
| **Backend**      | Node.js & Express.js        | Lightweight, event-driven REST API.           |
| **Real-Time**    | Periodic Polling            | Ensures updates without Firebase.             |

---

## 📁 Project Structure

```
📂 request-workflow-prototype/
├── request_handler_backend/    # Node.js backend
│   ├── server.js
│   └── package.json
│
├── request_handler_app/        # Flutter frontend
│   ├── lib/
│   │   └── data/api/api_service.dart
│   └── pubspec.yaml
│
└── README.md
```

---

## 🚀 Getting Started

### 1️⃣ Backend Setup (Node.js)

```bash
cd request_handler_backend
npm init -y
npm install express cors
node server.js
```

Backend runs at: **[http://localhost:3000](http://localhost:3000)**

---

### 2️⃣ Frontend Setup (Flutter)

```bash
cd request_handler_app
flutter pub get
```

➡️ Update **lib/data/api/api\_service.dart** with your local IP (e.g., `192.168.1.5`).

Run the app:

```bash
flutter run
```

**Default Credentials:**

* End User → `user1`
* Receiver → `receiver1`

---

## 🔌 API Endpoints

| Method | Endpoint                    | Description           |
| ------ | --------------------------- | --------------------- |
| POST   | `/api/login`                | Authenticate user     |
| GET    | `/api/items`                | Fetch list of items   |
| POST   | `/api/requests`             | Submit new request    |
| GET    | `/api/requests`             | Get requests by role  |
| PUT    | `/api/requests/:id/confirm` | Confirm item statuses |

---

## 🎬 Demo Workflow

1. **End User (user1)** logs in → dashboard is empty.
2. Creates request with 3–4 items.
3. Request shows as **Pending**.
4. **Receiver (receiver1)** logs in → sees new request.
5. Confirms some items as *Available*, others as *Not Available*.
6. Request disappears from Receiver’s pending list.
7. End User sees original request updated to **Partially Fulfilled**.
8. New Pending request is automatically created with only unfulfilled items.

