module todo_list::todo_list {
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::{event, transfer};
    use std::string::String;
    use std::vector;

    const ENotOwner: u64 = 0;
    const ETaskNotFound: u64 = 1;
    const EEmptyTitle: u64 = 2;

    public struct Task has store, copy, drop {
        id: u64,
        title: String,
        description: String,
        completed: bool,
    }

    public struct TodoList has key {
        id: UID,
        owner: address,
        tasks: vector<Task>,
        next_id: u64,
    }

    public struct TaskAdded has copy, drop {
        list_owner: address,
        task_id: u64,
        title: String,
    }

    public struct TaskCompleted has copy, drop {
        list_owner: address,
        task_id: u64,
    }

    public struct TaskDeleted has copy, drop {
        list_owner: address,
        task_id: u64,
    }

    public entry fun create_list(ctx: &mut TxContext) {
        let list = TodoList {
            id: object::new(ctx),
            owner: tx_context::sender(ctx),
            tasks: vector::empty<Task>(),
            next_id: 0,
        };
        transfer::transfer(list, tx_context::sender(ctx));
    }

    public entry fun add_task(
        list: &mut TodoList,
        title: String,
        description: String,
        ctx: &mut TxContext
    ) {
        assert!(tx_context::sender(ctx) == list.owner, ENotOwner);
        assert!(string::length(&title) > 0, EEmptyTitle);

        let task = Task {
            id: list.next_id,
            title,
            description,
            completed: false,
        };
        vector::push_back(&mut list.tasks, task);
        event::emit(TaskAdded {
            list_owner: list.owner,
            task_id: list.next_id,
            title: task.title,
        });
        list.next_id = list.next_id + 1;
    }

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

    public entry fun delete_task(list: &mut TodoList, task_id: u64, ctx: &mut TxContext) {
        assert!(tx_context::sender(ctx) == list.owner, ENotOwner);
        let index = find_task_index(&list.tasks, task_id);
        vector::remove(&mut list.tasks, index);
        event::emit(TaskDeleted {
            list_owner: list.owner,
            task_id,
        });
    }

    public fun task_count(list: &TodoList): u64 {
        vector::length(&list.tasks)
    }

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
