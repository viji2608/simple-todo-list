module todo::todo_list {

    use sui::tx_context;
    use sui::object;
    use sui::transfer;
    use std::vector;

    /// Represents a single task
    public struct Task has store, drop {
        id: u64,
        description: vector<u8>,
        completed: bool,
    }

    /// Represents a todo list owned by a user
    public struct TodoList has key {
        id: object::UID,
        owner: address,
        tasks: vector<Task>,
    }

    /// Create a new todo list object and assign it to the sender
    public fun create_list(ctx: &mut tx_context::TxContext) {
        let list = TodoList {
            id: object::new(ctx),
            owner: tx_context::sender(ctx),
            tasks: vector::empty<Task>(),
        };
        transfer::transfer(list, tx_context::sender(ctx));
    }

    /// Add a new task to the todo list
    public fun add_task(
        list: &mut TodoList,
        id: u64,
        description: vector<u8>,
        _ctx: &mut tx_context::TxContext
    ) {
        let task = Task { id, description, completed: false };
        vector::push_back(&mut list.tasks, task);
    }

    /// Mark a task as complete
    public fun complete_task(
        list: &mut TodoList,
        id: u64,
        _ctx: &mut tx_context::TxContext
    ) {
        let len = vector::length(&list.tasks);
        let mut i = 0u64;
        while (i < len) {
            let task_ref = vector::borrow_mut(&mut list.tasks, i);
            if (task_ref.id == id) {
                task_ref.completed = true;
                break
            };
            i = i + 1;
        };
    }

    /// Delete a task by ID
    public fun delete_task(
        list: &mut TodoList,
        id: u64,
        _ctx: &mut tx_context::TxContext
    ) {
        let len = vector::length(&list.tasks);
        let mut i = 0u64;
        while (i < len) {
            let task_ref = vector::borrow(&list.tasks, i);
            if (task_ref.id == id) {
                vector::remove(&mut list.tasks, i);
                break
            };
            i = i + 1;
        };
    }

    /// Get the number of tasks in the list
    public fun task_count(list: &TodoList): u64 {
        vector::length(&list.tasks)
    }
}
