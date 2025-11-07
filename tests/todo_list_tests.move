module todo::todo_list_tests {
    use sui::tx_context;
    use todo::todo_list;

    #[test]
    public fun test_todo_list(ctx: &mut tx_context::TxContext) {
        // Create a new TodoList
        let mut list = todo_list::create_list(ctx);

        // Add tasks
        todo_list::add_task(&mut list, 0, b"Write code", ctx);
        todo_list::add_task(&mut list, 1, b"Push code", ctx);

        // Complete and delete tasks
        todo_list::complete_task(&mut list, 0, ctx);
        todo_list::delete_task(&mut list, 1, ctx);
    }
}
