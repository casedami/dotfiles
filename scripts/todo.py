#!/usr/bin/env python3

import subprocess as sp
import argparse
import os
import datetime as dt
import tempfile
from enum import StrEnum


TODAY = "/Users/caseymiller/self/notes/main/tasks/today.md"
TOMORROW = "/Users/caseymiller/self/notes/main/tasks/tomorrow.md"
SELF = "/Users/caseymiller/self/notes/main/tasks/self.md"
UNI = "/Users/caseymiller/self/notes/main/tasks/uni.md"


class TodoType(StrEnum):
    TODO = " "
    DONE = "x"
    LATE = ">"


class CommandBuilder:
    def __init__(self) -> None:
        self.command = ""

    def __str__(self):
        return self.command

    def __add__(self, other):
        if not isinstance(other, str):
            raise TypeError(
                "Unable to perform addition operation on CommandBuilder object."
            )
        if self.command == "":
            self.command = other
        else:
            self.command += f" | {other}"
        return self

    def __mul__(self, other):
        if not isinstance(other, str):
            raise TypeError(
                "Unable to perform addition operation on CommandBuilder object."
            )
        if self.command == "":
            self.command = other
        else:
            self.command += f" ; {other}"
        return self

    def find(
        self,
        p: str | list[str],
        fp: str | None = None,
        todo: bool = True,
    ):
        if isinstance(p, list):
            pattern = "|".join(p)
        else:
            pattern = p

        if todo:
            pattern = f"\\[({pattern})\\]"

        if fp:
            command = f"grep -E '{pattern}' {filepath}"
        else:
            command = f"grep -E '{pattern}'"

        return command

    def find_and_append(
        self,
        p: str | list[str],
        dest: str,
        fp: str | None = None,
        todo: bool = True,
    ):
        command = self.find(p, fp, todo)
        return f"{command} >> {dest}"

    def replace(
        self,
        orig: str,
        new: str,
        fp: str | None = None,
        todo: bool = True,
    ):
        if todo:
            orig = f"\\[({orig})\\]"
            new = f"\\[({new})\\]"
        if fp:
            return f"sed -i '' -E 's/{orig}/{new}/' {fp}"
        return f"sed -E 's/{orig}/{new}/'"

    def delete(
        self,
        p: str | list[str],
        fp: str,
        todo: bool = True,
    ):
        if isinstance(p, list):
            pattern = "|".join(p)
        else:
            pattern = p
        if todo:
            pattern = f"\\[({pattern})\\]"

        return f"sed -i '' -E '/({pattern})/d' {fp}"

    def strip(self, p: str, prefix=False):
        if prefix:
            return f"sed -E 's/- \\[({p})\\]//'"
        match p:
            case TodoType.TODO:
                return f"sed -E 's/- \\[({p})\\]/-/'"
            case TodoType.DONE:
                return f"sed -E 's/- \\[({p})\\]/x/'"
            case TodoType.LATE:
                return f"sed -E 's/- \\[({p})\\]/>/'"


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
    parser.set_defaults(func=None)

    command_ls = subparsers.add_parser("ls", help="list tasks")
    command_ls.set_defaults(func=ls)

    command_new = subparsers.add_parser("new", help="create new task")
    command_new.set_defaults(func=new)

    command_clean = subparsers.add_parser("clean", help="remove finished tasks")
    command_clean.set_defaults(func=clean)

    command_restart = subparsers.add_parser("restart", help="remove all tasks")
    command_restart.set_defaults(func=restart)

    command_select = subparsers.add_parser("mk", help="select tasks to mark complete")
    command_select.set_defaults(func=select)

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


def ls(args, filepath: str) -> None:
    try:
        command = CommandBuilder()
        sp.check_output(
            command.find([TodoType.TODO, TodoType.DONE, TodoType.LATE], fp=filepath),
            shell=True,
        )
        if args.todo == "TODAY":
            outstr = "Here's your tasks for today:"
        else:
            outstr = "Here's your tasks:"
        print(outstr)
        print("-" * len(outstr))
        command += command.find(
            [TodoType.TODO, TodoType.DONE, TodoType.LATE], fp=filepath
        )
        command += command.strip(TodoType.TODO)
        command += command.strip(TodoType.DONE)
        command += command.strip(TodoType.LATE)
        command += "sort"
        sp.call(str(command), shell=True)
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


def clean(args, filepath: str) -> None:
    command = CommandBuilder()
    sp.call(command.delete(TodoType.TODO, filepath), shell=True)


def restart(args, filepath: str) -> None:
    command = CommandBuilder()
    sp.call(
        command.delete([TodoType.TODO, TodoType.DONE, TodoType.LATE], filepath),
        shell=True,
    )


def push(args, filepath: str) -> None:
    if args.todo == "TOMORROW":
        return
    if args.all:
        command = CommandBuilder()
        command *= command.replace(TodoType.LATE, TodoType.TODO, fp=filepath)
        command *= command.find_and_append(TodoType.TODO, TOMORROW, fp=filepath)
        sp.call(str(command), shell=True)
    else:
        select(args, filepath)
    if args.clear:
        restart(args, TODAY)


def select(args, filepath: str) -> None:
    selection = []
    with tempfile.NamedTemporaryFile(delete=False) as output_file:
        command = CommandBuilder()
        command += command.find([TodoType.TODO, TodoType.LATE], fp=filepath)
        command += command.strip(TodoType.TODO, prefix=True)
        command += command.strip(TodoType.LATE, prefix=True)
        command += f"fzf > {output_file.name}"
        sp.call(str(command), shell=True)

        with open(output_file.name, encoding="utf-8") as f:
            for line in f:
                selection.append(line.strip("\n"))

    os.unlink(output_file.name)
    for task in selection:
        task = task.strip()
        command = CommandBuilder()
        if args.func.__name__ == "push":
            command *= command.find_and_append(task, TOMORROW, fp=filepath, todo=False)
            command *= command.delete(task, filepath, todo=False)
        else:
            command = command.replace(
                f"\\[( |>)\\] {task}", f"\\[x\\] {task}", fp=filepath, todo=False
            )
        sp.call(str(command), shell=True)


if __name__ == "__main__":
    args = parse_args()

    match args.todo:
        case "TODAY":
            filepath = TODAY
        case "TOMORROW":
            filepath = TOMORROW
        case "SELF":
            filepath = SELF

    today = dt.datetime.now().date()
    filetime = dt.datetime.fromtimestamp(os.path.getmtime(TODAY))
    command = CommandBuilder()
    if filetime.date() != today:
        sp.call(command.replace(TodoType.TODO, TodoType.LATE, fp=filepath), shell=True)
        clean(args, TODAY)
        sp.call(command.find_and_append(TodoType.TODO, TODAY, fp=TOMORROW), shell=True)
        restart(args, TOMORROW)
        print("It's a new day  ")

    if args.func:
        args.func(args, filepath)
    else:
        sp.call(["nvim", filepath])
        exit()
