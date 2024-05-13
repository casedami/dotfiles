#!/opt/homebrew/Caskroom/miniconda/base/bin/python3

import argparse
import datetime as dt
import os
import re
import subprocess as sp
import tempfile
from enum import StrEnum

import humanize as hmn
from termcolor import colored

TODAY = "/Users/caseymiller/self/notes/main/tasks/today.md"
TOMORROW = "/Users/caseymiller/self/notes/main/tasks/tomorrow.md"
SELF = "/Users/caseymiller/self/notes/main/tasks/self.md"
UNI = "/Users/caseymiller/self/notes/main/tasks/uni.md"


def parse_args():
    parser = argparse.ArgumentParser(description="TODO CLI")
    subparsers = parser.add_subparsers(help="commands")
    filepath = parser.add_mutually_exclusive_group(required=False)
    filepath.add_argument(
        "-m",
        dest="todo",
        action="store_const",
        const="TOMORROW",
        default="TODAY",
        help="use 'tomorrow' tasks file",
    )
    filepath.add_argument(
        "-s",
        dest="todo",
        action="store_const",
        const="SELF",
        default="TODAY",
        help="use 'self' tasks file",
    )
    filepath.add_argument(
        "-u",
        dest="todo",
        action="store_const",
        const="UNI",
        default="TODAY",
        help="use 'uni' tasks file",
    )
    parser.set_defaults(func=None)

    command_ls = subparsers.add_parser("ls", help="list tasks")
    command_ls.set_defaults(func=ls)

    command_new = subparsers.add_parser("new", help="create new task")
    command_new.set_defaults(func=new)

    command_clean = subparsers.add_parser("clean", help="remove finished tasks")
    command_clean.set_defaults(func=clean)

    command_rm = subparsers.add_parser("rm", help="remove finished tasks")
    command_rm.set_defaults(func=remove)

    command_reset = subparsers.add_parser("reset", help="remove all tasks")
    command_reset.set_defaults(func=reset_todo)

    command_mark = subparsers.add_parser("mark", help="select tasks to mark complete")
    command_mark.set_defaults(func=mark)

    command_push = subparsers.add_parser("push", help="push tasks to tomorrow")
    command_push.add_argument(
        "-a",
        dest="all",
        action="store_true",
        default=False,
        help="push all incomplete tasks",
    )
    command_push.add_argument(
        "-c",
        dest="clear",
        action="store_true",
        default=False,
        help="push tasks but don't clear",
    )
    command_push.set_defaults(func=push)

    return parser.parse_args()


class TodoType(StrEnum):
    TODO = " "
    DONE = "x"
    LATE = ">"


class Priority:
    def __init__(self, priority: str, date: dt.datetime):
        self._level = priority
        self._date = date

    @property
    def level(self):
        return self._level

    @property
    def date(self):
        return self._date

    def __lt__(self, other):
        """
        higher priority and dated sooner
        higher priority
        dated
        """

        if other is None:
            return True
        if self.date is None or other.date is None:
            return self.level[-1] < other.level[-1]
        if self.date == other.date:
            return self.level[-1] < other.level[-1]
        if self.date < other.date:
            return True
        if self.date > other.date:
            return False


class CommandBuilder:
    def __init__(self, sep: str | None = None) -> None:
        if sep not in ("|", ";", None):
            raise ValueError("Invalid command separator. Use '|' or ';'")
        self.command = ""
        self.sep = sep

    def __str__(self):
        return self.command

    @property
    def string(self):
        return self.command

    def named(self, command: str):
        self.command = f" {self.sep} ".join(filter(None, [self.command, command]))
        return self

    def find(self, p: str | list[str], fp: str | None = None, todo: bool = True):
        if isinstance(p, list):
            pattern = f"({'|'.join(p)})"
        else:
            pattern = p

        if todo:
            pattern = f"\\[{pattern}\\]"

        if fp:
            command = f"grep -E '{pattern}' {fp}"
        else:
            command = f"grep -E '{pattern}'"

        self.command = f" {self.sep} ".join(filter(None, [self.command, command]))
        return self

    def append_to(self, dest: str):
        if not self.command:
            raise ValueError(f"Cannot append empty command to file '{dest}'.")
        self.command = " >> ".join(filter(None, [self.command, dest]))
        return self

    def replace(
        self,
        orig: str,
        new: str,
        fp: str | None = None,
        todo: bool = True,
    ):
        if todo:
            orig = f"\\[{orig}\\]"
            new = f"\\[{new}\\]"
        if fp:
            command = f"sed -i '' -E 's/{orig}/{new}/' {fp}"
        else:
            command = f"sed -E 's/{orig}/{new}/'"

        self.command = f" {self.sep} ".join(filter(None, [self.command, command]))
        return self

    def delete(self, p: str | list[str], fp: str, todo: bool = True):
        if isinstance(p, list):
            pattern = "|".join(p)
        else:
            pattern = p
        if todo:
            pattern = f"\\[({pattern})\\]"

        command = f"sed -i '' -E '/({pattern})/d' {fp}"
        self.command = f" {self.sep} ".join(filter(None, [self.command, command]))
        return self

    def strip(self, p: str, prefix: bool = False):
        if prefix:
            command = f"sed -E 's/- \\[({p})\\]//'"
        else:
            match p:
                case TodoType.TODO:
                    command = f"sed -E 's/- \\[({p})\\]/-/'"
                case TodoType.DONE:
                    command = f"sed -E 's/- \\[({p})\\]/x/'"
                case TodoType.LATE:
                    command = f"sed -E 's/- \\[({p})\\]/>/'"

        self.command = f" {self.sep} ".join(filter(None, [self.command, command]))
        return self


def sort_by_priority(filepath: str):
    with tempfile.NamedTemporaryFile(delete=False) as output_file:
        cmd = (
            CommandBuilder(sep="|")
            .find([TodoType.TODO, TodoType.LATE], fp=filepath)
            .strip(TodoType.TODO)
            .strip(TodoType.LATE)
            .named(f"sort > {output_file.name}")
            .string
        )
        sp.call(cmd, shell=True)

        with open(output_file.name) as f:
            tasks = f.read().splitlines()
            for task in tasks:
                task = task.strip()
    os.unlink(output_file.name)

    priorities = {}
    for i in range(len(tasks)):
        level = re.search("high|medium|low", tasks[i])
        date = re.search(r"\d\d\d\d-\d\d-\d\d", tasks[i])
        if date is not None:
            date = str2date(date.group())
        if level is not None:
            priorities[i] = Priority(level.group(), date)

    if len(priorities) == 0:
        return tasks

    for i in range(1, len(tasks)):
        j = i - 1
        key = tasks[i]
        while j >= 0 and priorities[i] < priorities[j]:
            tasks[j + 1] = tasks[j]
            priorities[j], priorities[j + 1] = priorities[j + 1], priorities[j]
            j -= 1
        tasks[j + 1] = key

    for i in range(len(tasks)):
        tasks[i] = print_priority(tasks[i], priorities[i])

    return tasks


def str2date(date: str) -> dt.datetime:
    year = int(date[0:4])
    month = int(date[5:7])
    day = int(date[8:])
    return dt.datetime(year, month, day)


def print_priority(task: str, priority: str):
    level, date = priority.level, priority.date
    out = re.sub(f"#{level}", "", task)
    if date is not None:
        out = re.sub(
            r" @{\d\d\d\d-\d\d-\d\d}",
            f"due in {hmn.naturaldelta(date - dt.datetime.now())}".upper(),
            out,
        )
    match level:
        case "high":
            out = colored(out, "red")
            return out
        case "medium":
            out = colored(out, "yellow")
            return out
        case "low":
            return out


def ls(args, filepath: str) -> None:
    try:
        clean(args, filepath)
        cmd = (
            CommandBuilder(sep="|")
            .find([TodoType.TODO, TodoType.LATE], fp=filepath)
            .string
        )
        sp.check_output(cmd, shell=True)

        if args.todo == "TODAY":
            outstr = "Here's your tasks for today:"
        elif args.todo == "TOMORROW":
            outstr = "Here's your tasks for tomorrow:"
        else:
            outstr = "Here's your tasks:"
        print(outstr)
        print("-" * len(outstr))
        tasks = sort_by_priority(filepath)
        for task in tasks:
            print(task)
    except sp.CalledProcessError:
        print("No tasks left to complete!")


def new(args, filepath: str) -> None:
    try:
        tasks = [task for task in input(">>> ").split(", ")]
        with open(filepath, "a") as f:
            for task in tasks:
                f.write(f"- [ ] {task}\n")
    except KeyboardInterrupt:
        print()


def remove(args, filepath: str) -> None:
    marked = select(filepath)
    for task in marked:
        task = task.strip()
        cmd = CommandBuilder().delete(task, filepath, todo=False).string
        sp.call(cmd, shell=True)


def clean(args, filepath: str) -> None:
    cmd = CommandBuilder().delete(TodoType.DONE, filepath).string
    sp.call(cmd, shell=True)


def reset_todo(args, filepath: str) -> None:
    cmd = (
        CommandBuilder()
        .delete([TodoType.TODO, TodoType.DONE, TodoType.LATE], filepath)
        .string
    )
    sp.call(cmd, shell=True)


def push(args, filepath: str) -> None:
    if args.todo == "TOMORROW":
        return
    if args.all:
        cmd = (
            CommandBuilder(sep=";")
            .replace(TodoType.LATE, TodoType.TODO, fp=filepath)
            .find(TodoType.TODO, fp=filepath)
            .append_to(TOMORROW)
            .string
        )
        sp.call(cmd, shell=True)
    else:
        marked = select(filepath)
        for task in marked:
            task = task.strip()
            cmd = (
                CommandBuilder(sep=";")
                .find(task, fp=filepath, todo=False)
                .append_to(TOMORROW)
                .delete(task, filepath, todo=False)
                .string
            )
            sp.call(cmd, shell=True)
    if args.clear:
        reset_todo(args, TODAY)


def mark(args, filepath: str) -> None:
    marked = select(filepath)
    for task in marked:
        task = task.strip()
        cmd = (
            CommandBuilder(sep=";")
            .replace(f"\\[( |>)\\] {task}", f"\\[x\\] {task}", fp=filepath, todo=False)
            .string
        )
        sp.call(cmd, shell=True)
    # TODO: clean if all items are marked


def select(filepath: str) -> None:
    selection = []
    with tempfile.NamedTemporaryFile(delete=False) as output_file:
        cmd = (
            CommandBuilder(sep="|")
            .find([TodoType.TODO, TodoType.LATE], fp=filepath)
            .strip(TodoType.TODO, prefix=True)
            .strip(TodoType.LATE, prefix=True)
            .named("sort")
            .named(f"fzf > {output_file.name}")
            .string
        )
        sp.call(cmd, shell=True)

        with open(output_file.name, encoding="utf-8") as f:
            for line in f:
                selection.append(line.strip("\n"))
    os.unlink(output_file.name)
    return selection


if __name__ == "__main__":
    args = parse_args()

    match args.todo:
        case "TODAY":
            filepath = TODAY
        case "TOMORROW":
            filepath = TOMORROW
        case "SELF":
            filepath = SELF
        case "UNI":
            filepath = UNI

    today = dt.datetime.now().date()
    filetime = dt.datetime.fromtimestamp(os.path.getmtime(TODAY))
    if filetime.date() != today:
        cmd = CommandBuilder().replace(TodoType.TODO, TodoType.LATE, fp=TODAY).string
        sp.call(cmd, shell=True)
        clean(args, TODAY)
        cmd = CommandBuilder().find(TodoType.TODO, fp=TOMORROW).append_to(TODAY).string
        sp.call(cmd, shell=True)
        reset_todo(args, TOMORROW)
        print("It's a new day  ")

    if args.func:
        args.func(args, filepath)
    else:
        sp.call(["nvim", filepath])
        exit()
