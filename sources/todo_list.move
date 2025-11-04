module todo_list::todo_list {
    use std::string::String;
    use sui::{event, object::{Self, UID}, transfer, tx_context::{Self, TxContext}};

    /// User's TODO list
    public struct TodoList has key {
        id: UID,
        owner: address,
        tasks: vector<Task>,
        next_task_id: u64,
    }

    /// Individual task
    public struct Task has copy, drop, store {
        id: u64,
        title: String,
        description: String,
        completed: bool,
    }

    /// Event when task is added
    public struct TaskAdded has copy, drop { list_id: address, task_id: u64, title: String }

    /// Create a new TODO list
    public entry fun create_list(ctx: &mut TxContext) {}

    /// Add a task to the list
    public entry fun add_task(
        list: &mut TodoList,
        title: String,
        description: String,
        ctx: &mut TxContext,
    ) {}

    /// Mark task as complete
    public entry fun complete_task(list: &mut TodoList, task_id: u64, _ctx: &mut TxContext) {}

    /// Delete a task
    public entry fun delete_task(list: &mut TodoList, task_id: u64, _ctx: &mut TxContext) {}
    
    /// Get total task count
    public fun task_count(list: &TodoList): u64 {}
}