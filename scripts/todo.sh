if [[ $# -eq 0 ]]; then
  nvim ~/self/uni/tasks/self.md
  exit 0
fi
if [[ "$1" == "new" ]]; then
  read -p ">>> " task
  task=$(echo $task | xargs)
  echo "- [ ] $task" >>~/self/uni/tasks/self.md
elif [[ "$1" == "ls" ]]; then
  cat ~/self/uni/tasks/self.md | sed 's/\[ \] //' | sed '1d'
else
  echo "unsupported or unknown args"
fi
