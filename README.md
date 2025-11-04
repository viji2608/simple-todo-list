# 📝 Simple TODO List – Sui Blockchain

A decentralized personal task manager built on the **Sui blockchain**, allowing users to create, manage, and track their own TODO lists.
Each user owns their own list, can add new tasks, mark them as complete, or delete them — all stored securely and verifiably on-chain.

---

## 🎯 Expected Output

✅ Each user can **create their own TODO list**
✅ Users can **add tasks** with a title and description
✅ Users can **mark tasks complete or incomplete**
✅ Users can **delete tasks**
✅ Each task has a **unique ID** within the list
✅ Users can **view the total number of tasks**

---

## ✅ Test Cases to Implement

| Test Case                    | Description                                   | Expected Result                   |
| ---------------------------- | --------------------------------------------- | --------------------------------- |
| **Create list and add task** | Creates a list and adds one task              | List created; task count = 1      |
| **Complete a task**          | Marks a task as complete                      | Task marked as completed = `true` |
| **Delete a task**            | Removes a task from the list                  | Task count decreases              |
| **Add multiple tasks**       | Adds several tasks to one list                | Correct total task count          |
| **Check ownership**          | Ensures users can modify only their own lists | Only owner can modify             |

---

## 🧩 Features

| Feature                  | Description                                 |
| ------------------------ | ------------------------------------------- |
| **Personalized Lists**   | Each user owns their own TODO list object   |
| **Task Management**      | Add, complete, and delete tasks easily      |
| **Unique Task IDs**      | Each task is assigned a unique numeric ID   |
| **Ownership Validation** | Only the owner can modify their list        |
| **Event Emission**       | Transparent tracking of all task operations |

---

## 📁 Project Structure

```
simple-todo-list/
├── Move.toml                      # Package configuration
├── sources/
│   └── todo_list.move             # Main smart contract logic
├── tests/
│   └── todo_list_tests.move       # Unit tests for task operations
└── README.md                      # Project documentation
```

---

## ⚙️ Contract Overview

| Function                                    | Purpose                | Description                                           |
| ------------------------------------------- | ---------------------- | ----------------------------------------------------- |
| **create_list(ctx)**                        | Create a new TODO list | Initializes a new list owned by the sender            |
| **add_task(list, title, description, ctx)** | Add a task             | Creates a task, adds to list, emits `TaskAdded` event |
| **complete_task(list, task_id, ctx)**       | Mark a task complete   | Sets `completed = true` for a task                    |
| **delete_task(list, task_id, ctx)**         | Delete a task          | Removes the task from the vector                      |
| **task_count(list)**                        | Get task count         | Returns number of tasks in the list                   |

---

## 🚨 Error Codes

| Code                  | Name           | Description                   |
| --------------------- | -------------- | ----------------------------- |
| **ENotOwner (0)**     | Not Owner      | Action attempted by non-owner |
| **ETaskNotFound (1)** | Task Not Found | Invalid or missing task ID    |
| **EEmptyTitle (2)**   | Empty Title    | Task title must not be empty  |

---

## 📢 Events

| Event             | Trigger                        | Description                      |
| ----------------- | ------------------------------ | -------------------------------- |
| **TaskAdded**     | When a task is created         | Logs list ID, task ID, and title |
| **TaskCompleted** | When a task is marked complete | Logs list ID and task ID         |
| **TaskDeleted**   | When a task is removed         | Logs list ID and task ID         |

---

## 🧪 Testing Focus

All test cases are located in `tests/todo_list_tests.move`.

| Test Name                       | Description                    | Expected Result      |
| ------------------------------- | ------------------------------ | -------------------- |
| `test_create_list_and_add_task` | Creates list and adds one task | Task count = 1       |
| `test_complete_task`            | Marks task complete            | Completed = true     |
| `test_delete_task`              | Deletes a task                 | Task count decreases |
| `test_multiple_tasks`           | Adds 3 tasks                   | Task count = 3       |
| `test_ownership_restriction`    | Non-owner tries to modify list | Transaction fails    |

---

## 🔐 Security & Safety

* **Ownership enforced** – only the creator of a list can modify it
* **Unique task IDs** – ensures consistency and avoids collisions
* **Validated inputs** – prevents empty or invalid task data
* **Immutable history** – event logs provide transparent change tracking

---

## 📘 Learning Highlights

This project demonstrates key **Sui Move** concepts:

* **Owned Objects** – how to bind data to user addresses
* **Vectors & Structs** – store and manipulate on-chain collections
* **Access Control** – enforce ownership restrictions
* **Event Emission** – log on-chain actions for transparency
* **State Management** – handle updates in a decentralized environment

---

## 🧰 How to Run

1. **Build the project**

   ```bash
   sui move build
   ```

2. **Run tests**

   ```bash
   sui move test
   ```

3. **Publish to the network**

   ```bash
   sui client publish --gas-budget 100000000
   ```

4. **Interact with the module**

   * Create list
   * Add tasks
   * Complete or delete tasks
   * Check counts

---

## 📜 License

This project was built for **educational and hackathon purposes**.
You’re encouraged to modify, extend, and improve it!

---

## 🎉 Ready for Hackathon!

Your **Simple TODO List** is fully ready for deployment!
Participants can now:
✅ Create personal TODO lists
✅ Manage and complete tasks
✅ Track progress transparently on the Sui blockchain

Good luck with your hackathon! 🏆

---