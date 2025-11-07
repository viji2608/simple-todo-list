#[test_only]
module todo_list::todo_list_tests {
    use std::string;
    use sui::tx_context;
    use todo_list::todo_list;

    #[test]
    public fun test_create_and_add_task(ctx: &mut tx_context::TxContext) {
        // Create a new list
        todo_list::create_list(ctx);
        let list = tx_context::take_from_sender<todo_list::TodoList>(ctx);

        // Add a task
        todo_list::add_task(&mut list, string::utf8(b"Buy milk"), string::utf8(b"From local store"), ctx);

        // Check task count
        let count = todo_list::task_count(&list);
        assert!(count == 1, 100);
    }

    #[test]
    public fun test_complete_and_delete_task(ctx: &mut tx_context::TxContext) {
        todo_list::create_list(ctx);
        let list = tx_context::take_from_sender<todo_list::TodoList>(ctx);

        todo_list::add_task(&mut list, string::utf8(b"Read book"), string::utf8(b"Chapter 1"), ctx);
        todo_list::complete_task(&mut list, 0, ctx);
        todo_list::delete_task(&mut list, 0, ctx);

        let count = todo_list::task_count(&list);
        assert!(count == 0, 101);
    }
}
