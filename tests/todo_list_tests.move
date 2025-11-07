/*
    📘 Module: todo_list::todo_list_tests
    -------------------------------------------------------------
    Purpose:
      This is a test-only module that verifies every function
      inside your main `todo_list` module.
*/

#[test_only]
module todo_list::todo_list_tests {
    use todo_list::todo_list::{Self, TodoList};
    use sui::test_scenario::{Self as ts, Scenario};
    use sui::transfer; // Required for transfer::public_transfer
    use std::string; // Required only if you use string::utf8 elsewhere

    // ---------------------------------------------------------
    // 📌 Constants
    // ---------------------------------------------------------
    const OWNER: address = @0xA;
    const OTHER_USER: address = @0xB; 

    // ---------------------------------------------------------
    // 🧰 Helper Function — Creates a fresh test scenario
    // ---------------------------------------------------------
    fun setup_test(): Scenario {
        let mut scenario = ts::begin(OWNER);
        {
            // Create a new empty to-do list for this test
            let ctx = ts::ctx(&mut scenario);
            let list = todo_list::create_list(ctx);
            
            // FIX E02009: Use public_transfer since TodoList has 'store'
            transfer::public_transfer(list, OWNER); 
        };
        scenario
    }

    // ---------------------------------------------------------
    // 🧪 Test 1: Check list creation
    // ---------------------------------------------------------
    #[test]
    fun test_create_list() {
        let mut scenario = ts::begin(OWNER);
        {
            let ctx = ts::ctx(&mut scenario);
            let list = todo_list::create_list(ctx);
            // FIX E02009: Use public_transfer for cleanup
            transfer::public_transfer(list, OWNER); 
        };

        ts::next_tx(&mut scenario, OWNER);
        {
            // Take the created list and verify ownership & count
            let list = ts::take_from_sender<TodoList>(&scenario);
            assert!(todo_list::get_task_count(&list) == 0, 0); 
            assert!(todo_list::get_owner(&list) == OWNER, 1);
            ts::return_to_sender(&scenario, list);
        };

        ts::end(scenario);
    }

    // ---------------------------------------------------------
    // 🧪 Test 2: Add a single task
    // ---------------------------------------------------------
    #[test]
    fun test_add_task() {
        let mut scenario = setup_test();

        ts::next_tx(&mut scenario, OWNER);
        {
            let mut list = ts::take_from_sender<TodoList>(&scenario);
            
            // FIX E04017: Removed the redundant 'ctx' argument
            todo_list::add_task(&mut list, b"Buy groceries"); 

            // Validate task count and content
            assert!(todo_list::get_task_count(&list) == 1, 0);
            let task = todo_list::get_task(&list, 0);
            
            // FIX E04007: Compare vector<u8> (from getter) to vector<u8> (b"...")
            assert!(todo_list::get_task_description(task) == b"Buy groceries", 1); 

            ts::return_to_sender(&scenario, list);
        };

        ts::end(scenario);
    }

    // ---------------------------------------------------------
    // 🧪 Test 3: Mark task as completed
    // ---------------------------------------------------------
    #[test]
    fun test_complete_task() {
        let mut scenario = setup_test();

        ts::next_tx(&mut scenario, OWNER);
        {
            let mut list = ts::take_from_sender<TodoList>(&scenario);
            
            // FIX E04017: Removed the redundant 'ctx' argument
            todo_list::add_task(&mut list, b"Finish homework");
            // FIX E04017: Removed the redundant 'ctx' argument
            todo_list::complete_task(&mut list, 0);

            let task = todo_list::get_task(&list, 0);
            assert!(todo_list::is_task_completed(task), 0);

            ts::return_to_sender(&scenario, list);
        };

        ts::end(scenario);
    }

    // ---------------------------------------------------------
    // 🧪 Test 4: Delete task
    // ---------------------------------------------------------
    #[test]
    fun test_delete_task() {
        let mut scenario = setup_test();

        ts::next_tx(&mut scenario, OWNER);
        {
            let mut list = ts::take_from_sender<TodoList>(&scenario);
            
            // FIX E04017: Removed the redundant 'ctx' argument
            todo_list::add_task(&mut list, b"Task 1");
            // FIX E04017: Removed the redundant 'ctx' argument
            todo_list::add_task(&mut list, b"Task 2");
            assert!(todo_list::get_task_count(&list) == 2, 0);

            // Delete first task (ID 0)
            todo_list::delete_task(&mut list, 0);
            assert!(todo_list::get_task_count(&list) == 1, 1);

            ts::return_to_sender(&scenario, list);
        };

        ts::end(scenario);
    }
}