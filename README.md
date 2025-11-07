# 📝 TODO List Module – Alkimi Week 2 Submission

## 📦 Overview
This Move module allows users to manage a personal TODO list on-chain. Each user can:
- Create their own list
- Add tasks with title and description
- Mark tasks as complete
- Delete tasks
- View total task count

## 🔧 Functions

| Function         | Description                                      |
|------------------|--------------------------------------------------|
| `create_list`    | Initializes a new TODO list for the sender       |
| `add_task`       | Adds a task with title and description           |
| `complete_task`  | Marks a task as completed                        |
| `delete_task`    | Removes a task by ID                             |
| `task_count`     | Returns the number of tasks in the list          |

## 🧪 Tests

Run tests using:
sui move test
Test cases include:

Creating a list

Adding tasks

Completing and deleting tasks

Verifying task count

🚀 Deployment
To publish on testnet:
sui client publish --gas-budget 100000000
🧰 How to Run Your To-Do List PackageThis section provides the exact Sui CLI commands needed to interact with the deployed todo_list package, demonstrating basic CRUD (Create, Read, Update, Delete) operations and other key features.🎯 Key Deployment DetailsDetailValuePublished Package ID0x459989c91f8135bddd817c8c778808b8543f862610ad740bb73f3dSender Address (Owner)0xa96f4d75d69f318a02a11b1a5c67ba978e38235291b79cbc2f608c595faddd9bTry It Yourself: Basic Operations (CRUD)Before starting, you must first create your list and set the environment variables.Step 1: Initialize Your List (Create)Run this first. The output will provide the Object ID of your new TodoList. Save this ID.Bash# Creates a new TodoList object and transfers it to your address.
sui client call \
  --function create_list \
  --module todo_list \
  --package 0x459989c91f8135bddd817c8c778808b8543f862610ad740bb73f3d \
  --gas-budget 10000000 

# 💡 IMPORTANT: Replace the placeholder below with the actual Object ID you receive.
export PKG=0x459989c91f8135bddd817c8c778808b8543f862610ad740bb73f3d
export LIST=0xYOUR_NEWLY_CREATED_TODO_LIST_OBJECT_ID_HERE
Step 2: Add Tasks (Create)Use the add_task function. The arguments are the List ID and the task description.Bash# Add the first task (gets ID 0)
sui client call \
  --package $PKG \
  --module todo_list \
  --function add_task \
  --args $LIST "Review Move code" \
  --gas-budget 10000000

# Add a second task (gets ID 1)
sui client call \
  --package $PKG \
  --module todo_list \
  --function add_task \
  --args $LIST "Update README" \
  --gas-budget 10000000
Step 3: Complete a Task (Update)Use complete_task with the List ID and the Task ID (0 or 1 in this case).Bash# Complete the first task (ID 0)
sui client call \
  --package $PKG \
  --module todo_list \
  --function complete_task \
  --args $LIST 0 \
  --gas-budget 10000000
Step 4: Check the List State (Read)You can read the full state of your TodoList object directly from the chain using the sui client object command.Bash# Check the JSON state of your list object (Read operation)
sui client object $LIST --json
Step 5: Delete a Task (Delete)Use delete_task with the List ID and the Task ID to permanently remove it.Bash# Delete the second task (ID 1)
sui client call \
  --package $PKG \
  --module todo_list \
  --function delete_task \
  --args $LIST 1 \
  --gas-budget 10000000
🔒 Authorization & Edge CasesThe structure of the TodoList provides inherent authorization and handles many edge cases.🛡️ Owner-Only Modification (Authorization)Guardrail: Since the TodoList object is a key-able object and is owned by the creator, only the owner's address can pass it as a mutable argument (&mut TodoList) to an entry function.Result: If a non-owner tries to run Steps 2, 3, or 5, the transaction will fail because the network will reject attempts by an unauthorized address to modify an owned object.⛔ Edge Cases HandledScenarioBehavior in CodeCLI CommandNonexistent TaskThe functions (complete_task, delete_task) iterate through the list. If the task_id is not found, the loop finishes, and the list remains unchanged.sui client call ... --args $LIST 999 (No change)Double CompletionIf you call complete_task on an already completed task, the logic attempts to set completed = true again, which is harmless, and the state remains true.sui client call ... --args $LIST 0 (No change)Empty Task DescriptionThe description argument is a vector<u8>. Passing empty quotes ("") results in an empty vector being stored. The package does not explicitly validate for non-empty input.sui client call ... --args $LIST "" (Task created with empty description)🤝 Collaboration Flow (Future Extension)The current package is strictly single-owner. To enable collaboration (grant, use, revoke), the package would need to be upgraded to:Introduce a separate object (e.g., a PermissionCap or a SharedList object).Add a public entry function like share_list(list: &mut TodoList, recipient: address).Modify all other functions (add_task, complete_task, etc.) to accept either the List Owner OR a valid Permission Object as an argument.This current version does not support multi-user collaboration.
OUTPUT:
Transaction Digest: GgCYMvjcxStg6aH9rWZqCPQw953hoZ8NcdhjePfGS9e4
╭──────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ Transaction Data                                                                                             │
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ Sender: 0xa96f4d75d69f318a02a11b1a5c67ba978e38235291b79cbc2f608c595faddd9b                                   │
│ Gas Owner: 0xa96f4d75d69f318a02a11b1a5c67ba978e38235291b79cbc2f608c595faddd9b                                │
│ Gas Budget: 500000000 MIST                                                                                   │
│ Gas Price: 1000 MIST                                                                                         │
│ Gas Payment:                                                                                                 │
│  ┌──                                                                                                         │
│  │ ID: 0x571d3ef6676ad32fbecc5b7b26a3b61536cc55cfbe1ce2c102a47142e8c23a96                                    │
│  │ Version: 349180891                                                                                        │
│  │ Digest: BwmKkBc4RH7cqcnXmyRJgiBhx8gdGKMQe6TyB16BK2E3                                                      │
│  └──                                                                                                         │
│                                                                                                              │
│ Transaction Kind: Programmable                                                                               │
│ ╭──────────────────────────────────────────────────────────────────────────────────────────────────────────╮ │
│ │ Input Objects                                                                                            │ │
│ ├──────────────────────────────────────────────────────────────────────────────────────────────────────────┤ │
│ │ 0   Pure Arg: Type: address, Value: "0xa96f4d75d69f318a02a11b1a5c67ba978e38235291b79cbc2f608c595faddd9b" │ │
│ ╰──────────────────────────────────────────────────────────────────────────────────────────────────────────╯ │
│ ╭─────────────────────────────────────────────────────────────────────────╮                                  │
│ │ Commands                                                                │                                  │
│ ├─────────────────────────────────────────────────────────────────────────┤                                  │
│ │ 0  Publish:                                                             │                                  │
│ │  ┌                                                                      │                                  │
│ │  │ Dependencies:                                                        │                                  │
│ │  │   0x0000000000000000000000000000000000000000000000000000000000000001 │                                  │
│ │  │   0x0000000000000000000000000000000000000000000000000000000000000002 │                                  │
│ │  └                                                                      │                                  │
│ │                                                                         │                                  │
│ │ 1  TransferObjects:                                                     │                                  │
│ │  ┌                                                                      │                                  │
│ │  │ Arguments:                                                           │                                  │
│ │  │   Result 0                                                           │                                  │
│ │  │ Address: Input  0                                                    │                                  │
│ │  └                                                                      │                                  │
│ ╰─────────────────────────────────────────────────────────────────────────╯                                  │
│                                                                                                              │
│ Signatures:                                                                                                  │
│    fOxX8HiH6uQ96iKiBCJ/9t7VaoxMymBfZNb9kkeFDoI6QE+MwHx5OKafltf4LhL28yPBLdttF/FLN6w955ifCQ==                  │
│                                                                                                              │
╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
╭───────────────────────────────────────────────────────────────────────────────────────────────────╮
│ Transaction Effects                                                                               │
├───────────────────────────────────────────────────────────────────────────────────────────────────┤
│ Digest: GgCYMvjcxStg6aH9rWZqCPQw953hoZ8NcdhjePfGS9e4                                              │
│ Status: Success                                                                                   │
│ Executed Epoch: 911                                                                               │
│                                                                                                   │
│ Created Objects:                                                                                  │
│  ┌──                                                                                              │
│  │ ID: 0x459989c91f8135bddd817c8c778808b8543f86261046ccc20610ad740bb73f3d                         │
│  │ Owner: Immutable                                                                               │
│  │ Version: 1                                                                                     │
│  │ Digest: 7xETQMXUZWJHQS7Cru1TjdgrS9U2tgaJxQvdyyDR3kU7                                           │
│  └──                                                                                              │
│  ┌──                                                                                              │
│  │ ID: 0xb1051d8a003ba1372652788428981b550d02ca6f9bbf4f14ea7affff84af01bd                         │
│  │ Owner: Account Address ( 0xa96f4d75d69f318a02a11b1a5c67ba978e38235291b79cbc2f608c595faddd9b )  │
│  │ Version: 349180892                                                                             │
│  │ Digest: Ef5ATSAfw8rxYwYjpcuEc57SoGzBTQbEUeLdXSpZFsgJ                                           │
│  └──                                                                                              │
│ Mutated Objects:                                                                                  │
│  ┌──                                                                                              │
│  │ ID: 0x571d3ef6676ad32fbecc5b7b26a3b61536cc55cfbe1ce2c102a47142e8c23a96                         │
│  │ Owner: Account Address ( 0xa96f4d75d69f318a02a11b1a5c67ba978e38235291b79cbc2f608c595faddd9b )  │
│  │ Version: 349180892                                                                             │
│  │ Digest: 7pyk2Afs1naoSS6y2cBrLdH35rb2bmhP9pHUmDRcS4id                                           │
│  └──                                                                                              │
│ Gas Object:                                                                                       │
│  ┌──                                                                                              │
│  │ ID: 0x571d3ef6676ad32fbecc5b7b26a3b61536cc55cfbe1ce2c102a47142e8c23a96                         │
│  │ Owner: Account Address ( 0xa96f4d75d69f318a02a11b1a5c67ba978e38235291b79cbc2f608c595faddd9b )  │
│  │ Version: 349180892                                                                             │
│  │ Digest: 7pyk2Afs1naoSS6y2cBrLdH35rb2bmhP9pHUmDRcS4id                                           │
│  └──                                                                                              │
│ Gas Cost Summary:                                                                                 │
│    Storage Cost: 11894000 MIST                                                                    │
│    Computation Cost: 1000000 MIST                                                                 │
│    Storage Rebate: 978120 MIST                                                                    │
│    Non-refundable Storage Fee: 9880 MIST                                                          │
│                                                                                                   │
│ Transaction Dependencies:                                                                         │
│    BmkcAgVDSKf7Hvk1jxQjgh4C2PqqfWZvAUcSvCmjq8Zc                                                   │
│    Dd9pn1zFcSJjinxQewFd2gQdR4XKsHxFioD5MYnwLZQz                                                   │
│    GppkRKgQ5ZXNWpCC3BTd9tXG4zF3ACacZK9Pu8eCvJiz                                                   │
╰───────────────────────────────────────────────────────────────────────────────────────────────────╯
╭─────────────────────────────╮
│ No transaction block events │
╰─────────────────────────────╯

╭──────────────────────────────────────────────────────────────────────────────────────────────────╮
│ Object Changes                                                                                   │
├──────────────────────────────────────────────────────────────────────────────────────────────────┤
│ Created Objects:                                                                                 │
│  ┌──                                                                                             │
│  │ ObjectID: 0xb1051d8a003ba1372652788428981b550d02ca6f9bbf4f14ea7affff84af01bd                  │
│  │ Sender: 0xa96f4d75d69f318a02a11b1a5c67ba978e38235291b79cbc2f608c595faddd9b                    │
│  │ Owner: Account Address ( 0xa96f4d75d69f318a02a11b1a5c67ba978e38235291b79cbc2f608c595faddd9b ) │
│  │ ObjectType: 0x2::package::UpgradeCap                                                          │
│  │ Version: 349180892                                                                            │
│  │ Digest: Ef5ATSAfw8rxYwYjpcuEc57SoGzBTQbEUeLdXSpZFsgJ                                          │
│  └──                                                                                             │
│ Mutated Objects:                                                                                 │
│  ┌──                                                                                             │
│  │ ObjectID: 0x571d3ef6676ad32fbecc5b7b26a3b61536cc55cfbe1ce2c102a47142e8c23a96                  │
│  │ Sender: 0xa96f4d75d69f318a02a11b1a5c67ba978e38235291b79cbc2f608c595faddd9b                    │
│  │ Owner: Account Address ( 0xa96f4d75d69f318a02a11b1a5c67ba978e38235291b79cbc2f608c595faddd9b ) │
│  │ ObjectType: 0x2::coin::Coin<0x2::sui::SUI>                                                    │
│  │ Version: 349180892                                                                            │
│  │ Digest: 7pyk2Afs1naoSS6y2cBrLdH35rb2bmhP9pHUmDRcS4id                                          │
│  └──                                                                                             │
│ Published Objects:                                                                               │
│  ┌──                                                                                             │
│  │ PackageID: 0x459989c91f8135bddd817c8c778808b8543f86261046ccc20610ad740bb73f3d                 │
│  │ Version: 1                                                                                    │
│  │ Digest: 7xETQMXUZWJHQS7Cru1TjdgrS9U2tgaJxQvdyyDR3kU7                                          │
│  │ Modules: todo_list                                                                            │
│  └──                                                                                             │
╰──────────────────────────────────────────────────────────────────────────────────────────────────╯
╭───────────────────────────────────────────────────────────────────────────────────────────────────╮
│ Balance Changes                                                                                   │
├───────────────────────────────────────────────────────────────────────────────────────────────────┤
│  ┌──                                                                                              │
│  │ Owner: Account Address ( 0xa96f4d75d69f318a02a11b1a5c67ba978e38235291b79cbc2f608c595faddd9b )  │
│  │ CoinType: 0x2::sui::SUI                                                                        │
│  │ Amount: -11915880                                                                              │
│  └──                                                                                              │
╰───────────────────────────────────────────────────────────────────────────────────────────────────╯