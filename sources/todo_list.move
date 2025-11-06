module simple_todo_list::todo_list {
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    use sui::event;
    use std::string::String;
    use std::vector;

    /// Error codes for common failures
    const ENotOwner: u64 = 0;         // Raised when a non-owner tries to modify the list
    const ETaskNotFound: u64 = 1;     // Raised when a task ID is not found
    const EEmptyTitle: u64 = 2;       // Raised when a task title is empty

    /// Represents a single task in the TODO list
    struct Task has store, copy, drop {
        id: u64,                      // Unique task ID
        title: String,               // Task title
        description: String,         // Optional task details
        completed: bool,             // Completion status
    }

    /// Represents the user's TODO list object
    struct TodoList has key {
        id: UID,                     // Unique object ID
        owner: address,             // Address of the list creator
        tasks: vector<Task>,        // List of tasks
        next_id: u64,               // Counter to assign unique task IDs
    }

    /// Event emitted when a task is added
    struct TaskAdded has copy, drop {
        list_owner: address,
        task_id: u64,
        title: String,
    }

    /// Event emitted when a task is marked complete
    struct TaskCompleted has copy, drop {
        list_owner: address,
        task_id: u64,
    }

    /// Event emitted when a task is deleted
    struct TaskDeleted has copy, drop {
        list_owner: address,
        task_id: u64,
    }

    /// Creates a new TODO list and transfers it to the sender
    /// This function is called once per user to initialize their list
    public entry fun create_list(ctx: &mut TxContext) {
        let list = TodoList {
            id: object::new(ctx),
            owner: tx_context::sender(ctx),
            tasks: vector::empty<Task>(),
            next_id: 0,
        };
        transfer::transfer(list, tx_context::sender(ctx));
    }

    /// Adds a new task to the user's TODO list
    /// Validates ownership and non-empty title, then appends the task
    public entry fun add_task(
        list: &mut TodoList,
        title: String,
        description: String,
        ctx: &mut TxContext
    ) {
        // Ensure only the owner can add tasks
        assert!(tx_context::sender(ctx) == list.owner, ENotOwner);
        // Ensure title is not empty
        assert!(string::length(&title) > 0, EEmptyTitle);

        // Create new task with unique ID
        let task = Task {
            id: list.next_id,
            title,
            description,
            completed: false,
        };
        // Add task to the list
        vector::push_back(&mut list.tasks, task);
        // Emit event for transparency
        event::emit(TaskAdded {
            list_owner: list.owner,
            task_id: list.next_id,
            title: task.title,
        });
        // Increment task ID counter
        list.next_id = list.next_id + 1;
    }

    /// Marks a specific task as completed
    /// Validates ownership and task existence
    public entry fun complete_task(list: &mut TodoList, task_id: u64, ctx: &mut TxContext) {
        assert!(tx_context::sender(ctx) == list.owner, ENotOwner);
        let index = find_task_index(&list.tasks, task_id);
        let task = vector::borrow_mut(&mut list.tasks, index);
        task.completed = true;
        event::emit(TaskCompleted {
            list_owner: list.owner,
            task_id,
        });
    }

    /// Deletes a task from the list by ID
    /// Validates ownership and task existence
    public entry fun delete_task(list: &mut TodoList, task_id: u64, ctx: &mut TxContext) {
        assert!(tx_context::sender(ctx) == list.owner, ENotOwner);
        let index = find_task_index(&list.tasks, task_id);
        vector::remove(&mut list.tasks, index);
        event::emit(TaskDeleted {
            list_owner: list.owner,
            task_id,
        });
    }

    /// Returns the total number of tasks in the list
    /// Useful for UI display or analytics
    public fun task_count(list: &TodoList): u64 {
        vector::length(&list.tasks)
    }

    /// Internal helper to find the index of a task by its ID
    /// Returns the index or aborts if not found
    fun find_task_index(tasks: &vector<Task>, task_id: u64): u64 {
        let len = vector::length(tasks);
        let mut i = 0;
        while (i < len) {
            let task = vector::borrow(tasks, i);
            if (task.id == task_id) {
                return i;
            };
            i = i + 1;
        };
        abort ETaskNotFound;
    }
}
