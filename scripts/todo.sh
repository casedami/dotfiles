read -p "Enter new task: " task
task=$(echo $task | xargs)
echo "- [ ] $task" >>~/self/uni/tasks/self.md
