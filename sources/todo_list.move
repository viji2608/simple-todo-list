module todo_list::todo_list {
    use std::vector;
    use sui::object::{UID};
    use sui::tx_context;

    //
    // --- Struct Definitions ---
    //

    /// Represents a single to-do task
    public struct Task has store, drop { 
        id: u64,
        description: vector<u8>,
        completed: bool,
    }

    /// Represents a TodoList object owned by a user
    public struct TodoList has store, key {
        id: UID,
        owner: address,
        tasks: vector<Task>,
        next_task_id: u64,
    }

    //
    // --- Core Functions ---
    //

    /// Create a new TodoList object
    public fun create_list(ctx: &mut tx_context::TxContext): TodoList {
        let id = sui::object::new(ctx);
        TodoList {
            id,
            owner: tx_context::sender(ctx),
            tasks: vector::empty<Task>(),
            next_task_id: 0,
        }
    }

    /// Add a new task
    public fun add_task(list: &mut TodoList, description: vector<u8>) {
        let task = Task {
            id: list.next_task_id,
            description,
            completed: false,
        };
        vector::push_back(&mut list.tasks, task);
        list.next_task_id = list.next_task_id + 1;
    }

    /// Mark a task as completed
    public fun complete_task(list: &mut TodoList, task_id: u64) {
        let mut i = 0;
        while (i < vector::length(&list.tasks)) {
            let t_ref = vector::borrow_mut(&mut list.tasks, i); 
            if (t_ref.id == task_id) {
                t_ref.completed = true;
                break
            };
            i = i + 1;
        }
    }

    /// Delete a task by id
    public fun delete_task(list: &mut TodoList, task_id: u64) {
        let mut i = 0;
        while (i < vector::length(&list.tasks)) {
            let t_ref = vector::borrow(&list.tasks, i); 
            if (t_ref.id == task_id) {
                let _removed_task = vector::remove(&mut list.tasks, i); 
                break
            };
            i = i + 1;
        }
    }
    
    //
    // --- Public View Functions (Getters for Testing) ---
    //

    /// Returns the number of tasks
    public fun get_task_count(list: &TodoList): u64 {
        vector::length(&list.tasks)
    }

    /// Returns the owner of the TodoList
    public fun get_owner(list: &TodoList): address {
        list.owner
    }

    /// Returns a reference to a specific task
    public fun get_task(list: &TodoList, index: u64): &Task {
        vector::borrow(&list.tasks, index)
    }

    /// Returns a task’s description
    public fun get_task_description(task: &Task): vector<u8> {
        task.description
    }

    /// Returns whether a task is completed
    public fun is_task_completed(task: &Task): bool {
        task.completed
    }
}
