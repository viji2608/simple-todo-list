module simple_todo_list::todo_list_tests {
    use std::string;
    use std::vector;
    use sui::tx_context::TxContext;
    use simple_todo_list::todo_list::{TodoList, add_task, create_list, complete_task, delete_task, task_count};

    #[test]
    public entry fun test_add_and_count(ctx: &mut TxContext) {
        create_list(ctx);
        let mut list = borrow_global_mut<TodoList>(tx_context::sender(ctx));
        add_task(&mut list, string::utf8(b"Buy milk"), string::utf8(b"From local store"), ctx);
        add_task(&mut list, string::utf8(b"Read book"), string::utf8(b"Chapter 5"), ctx);
        let count = task_count(&list);
        assert!(count == 2, 100);
    }

    #[test]
    public entry fun test_complete_and_delete(ctx: &mut TxContext) {
        create_list(ctx);
        let mut list = borrow_global_mut<TodoList>(tx_context::sender(ctx));
        add_task(&mut list, string::utf8(b"Write code"), string::utf8(b"Finish module"), ctx);
        complete_task(&mut list, 0, ctx);
        delete_task(&mut list, 0, ctx);
        let count = task_count(&list);
        assert!(count == 0, 101);
    }
}
