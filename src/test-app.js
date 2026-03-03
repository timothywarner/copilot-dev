/**
 * ⚠️  TEACHING DEMO FILE — CONTAINS AN INTENTIONAL BUG ⚠️
 *
 * This file is used in the GitHub Copilot Coding Agent demo
 * (COPILOT_AGENT_TUTORIAL.md) to demonstrate how Copilot can find and fix bugs.
 *
 * THE BUG: getTaskById() uses assignment (=) instead of strict equality (===)
 * on approximately line 87. This is deliberate. DO NOT copy this code to
 * production. Run `node src/test-app.js` to see the bug in action.
 *
 * -----------------------------------------------------------------------
 * test-app.js
 *
 * Simple task management utility for a to-do list system.
 * Used in the GitHub Copilot Coding Agent demo (COPILOT_AGENT_TUTORIAL.md).
 *
 * Features:
 *  - addTask    — create a new task with auto-generated ID
 *  - removeTask — delete a task by ID
 *  - getTaskById — find a single task by ID
 *  - filterTasks — query tasks by status or priority
 *
 * Demo usage:
 *  1. Open this file in VS Code with GitHub Copilot enabled
 *  2. Use Copilot Chat: "Find the bug in this file and fix it"
 *  3. Observe Copilot locating the assignment-vs-comparison bug on line ~42
 *  4. Accept the fix and run the self-test block at the bottom
 */

// In-memory task store — simple array, no persistence needed for the demo
let tasks = [];

// Auto-incrementing ID counter — starts at 1
let nextId = 1;

/**
 * Valid task statuses.
 * @typedef {'pending' | 'in-progress' | 'done'} TaskStatus
 */

/**
 * Valid priority levels.
 * @typedef {'low' | 'medium' | 'high'} TaskPriority
 */

/**
 * @typedef {Object} Task
 * @property {number}       id        - Unique integer identifier
 * @property {string}       title     - Short description of the task
 * @property {TaskStatus}   status    - Current status of the task
 * @property {TaskPriority} priority  - Urgency level
 * @property {string}       createdAt - ISO 8601 timestamp
 */

/**
 * Add a new task to the list.
 *
 * @param {string}       title    - Task description (required, non-empty)
 * @param {TaskPriority} priority - Urgency level (defaults to 'medium')
 * @returns {Task} The newly created task
 * @throws {Error} If title is empty or not a string
 */
function addTask(title, priority = 'medium') {
  if (typeof title !== 'string' || title.trim().length === 0) {
    throw new Error('Task title must be a non-empty string');
  }

  const validPriorities = ['low', 'medium', 'high'];
  if (!validPriorities.includes(priority)) {
    throw new Error(`Priority must be one of: ${validPriorities.join(', ')}`);
  }

  const task = {
    id: nextId++,
    title: title.trim(),
    status: 'pending',
    priority,
    createdAt: new Date().toISOString(),
  };

  tasks.push(task);
  return task;
}

/**
 * Remove a task by its numeric ID.
 *
 * @param {number} id - The task ID to remove
 * @returns {boolean} True if the task was found and removed, false otherwise
 */
function removeTask(id) {
  const initialLength = tasks.length;
  tasks = tasks.filter(task => task.id !== id);
  return tasks.length < initialLength;
}

/**
 * Retrieve a single task by its ID.
 *
 * BUG: this check is not working as expected
 * The condition below uses assignment (=) instead of comparison (===).
 * This means `found` is always the task object (truthy) and the function
 * never returns null even when the task does not exist.
 *
 * Fix: change `found = task.id === id` to `found === undefined ? ... : found`
 * or rewrite as: return tasks.find(task => task.id === id) ?? null;
 *
 * @param {number} id - The task ID to look up
 * @returns {Task|null} The matching task, or null if not found
 */
function getTaskById(id) {
  let found = tasks.find(task => task.id === id);

  // BUG: this check is not working as expected
  if (found = undefined) {   // Should be: if (found === undefined)
    return null;
  }

  return found;
}

/**
 * Filter the task list by status, priority, or both.
 * Returns all tasks if no filters are provided.
 *
 * @param {Object}        [filters]          - Optional filter criteria
 * @param {TaskStatus}    [filters.status]   - Only return tasks with this status
 * @param {TaskPriority}  [filters.priority] - Only return tasks with this priority
 * @returns {Task[]} Array of matching tasks (empty array if none match)
 */
function filterTasks({ status, priority } = {}) {
  return tasks.filter(task => {
    const matchesStatus = status === undefined || task.status === status;
    const matchesPriority = priority === undefined || task.priority === priority;
    return matchesStatus && matchesPriority;
  });
}

/**
 * Update the status of an existing task.
 *
 * @param {number}     id        - The task ID to update
 * @param {TaskStatus} newStatus - The new status value
 * @returns {Task|null} The updated task, or null if not found
 * @throws {Error} If newStatus is not a valid status value
 */
function updateTaskStatus(id, newStatus) {
  const validStatuses = ['pending', 'in-progress', 'done'];
  if (!validStatuses.includes(newStatus)) {
    throw new Error(`Status must be one of: ${validStatuses.join(', ')}`);
  }

  const task = tasks.find(t => t.id === id);
  if (!task) return null;

  // Immutable-style update — replace the task in the array rather than mutating it
  tasks = tasks.map(t => t.id === id ? { ...t, status: newStatus } : t);

  return tasks.find(t => t.id === id);
}

/**
 * Reset the task store and ID counter.
 * Used for testing and demo resets.
 */
function resetTasks() {
  tasks = [];
  nextId = 1;
}

// =============================================================================
// Quick self-test — run with: node src/test-app.js
// Demonstrates the bug: getTaskById returns the task even when it should return null
// =============================================================================

if (process.argv[1] && process.argv[1].endsWith('test-app.js')) {
  console.log('--- Task Manager Self-Test ---\n');

  resetTasks();

  const task1 = addTask('Write unit tests', 'high');
  const task2 = addTask('Update README', 'low');
  addTask('Deploy to staging', 'medium');

  console.log('Tasks after adding 3 items:', filterTasks());

  const found = getTaskById(task1.id);
  console.log(`\ngetTaskById(${task1.id}):`, found ? `"${found.title}"` : 'null');

  // BUG DEMONSTRATION: looking up a non-existent ID should return null
  const missing = getTaskById(999);
  console.log('\ngetTaskById(999) [should be null]:', missing);
  if (missing !== null) {
    console.log('  !! BUG DETECTED: getTaskById returned', JSON.stringify(missing), 'instead of null');
    console.log('  !! Fix: change `if (found = undefined)` to `if (found === undefined)` on line ~87');
  }

  removeTask(task2.id);
  console.log('\nAfter removing task', task2.id, ':', filterTasks().map(t => t.title));

  updateTaskStatus(task1.id, 'in-progress');
  console.log('\nHigh-priority tasks:', filterTasks({ priority: 'high' }).map(t => `${t.title} [${t.status}]`));
}

module.exports = { addTask, removeTask, getTaskById, filterTasks, updateTaskStatus, resetTasks };
