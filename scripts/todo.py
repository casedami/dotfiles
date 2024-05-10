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
    def __init__(self, sep: str | None = None) -> None:
        if sep not in ("|", ";", None):
            raise ValueError("Invalid command separator. Use '|' or ';'")
        self.command = ""
        self.sep = sep

    def __str__(self):
        return self.command

    def reset(self):
        self.command = ""

    def named(self, command: str):
        if self.sep:
            self.command = f" {self.sep} ".join(filter(None, [self.command, command]))
        else:
            self.command = command
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

        if self.sep:
            self.command = f" {self.sep} ".join(filter(None, [self.command, command]))
        else:
            self.command = command
        return self

    def append_to(
        self,
        dest: str,
    ):
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
            orig = f"\\[({orig})\\]"
            new = f"\\[({new})\\]"
        if fp:
            command = f"sed -i '' -E 's/{orig}/{new}/' {fp}"
        else:
            command = f"sed -E 's/{orig}/{new}/'"

        if self.sep:
            self.command = f" {self.sep} ".join(filter(None, [self.command, command]))
        else:
            self.command = command
        return self

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

        command = f"sed -i '' -E '/({pattern})/d' {fp}"
        if self.sep:
            self.command = f" {self.sep} ".join(filter(None, [self.command, command]))
        else:
            self.command = command
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

        if self.sep:
            self.command = f" {self.sep} ".join(filter(None, [self.command, command]))
        else:
            self.command = command
        return self


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

    command_reset = subparsers.add_parser("reset", help="remove all tasks")
    command_reset.set_defaults(func=reset_todo)

    command_select = subparsers.add_parser("mark", help="select tasks to mark complete")
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
        cb = CommandBuilder(sep="|")
        cb.find([TodoType.TODO, TodoType.DONE, TodoType.LATE], fp=filepath)
        sp.check_output(str(cb), shell=True)
        if args.todo == "TODAY":
            outstr = "Here's your tasks for today:"
        else:
            outstr = "Here's your tasks:"
        print(outstr)
        print("-" * len(outstr))
        cb.strip(TodoType.TODO)
        cb.strip(TodoType.DONE)
        cb.strip(TodoType.LATE)
        cb.named("sort")
        sp.call(str(cb), shell=True)
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
    cb = CommandBuilder()
    cb.delete(TodoType.DONE, filepath)
    sp.call(str(cb), shell=True)


def reset_todo(args, filepath: str) -> None:
    cb = CommandBuilder()
    cb.delete([TodoType.TODO, TodoType.DONE, TodoType.LATE], filepath)
    sp.call(str(cb), shell=True)


def push(args, filepath: str) -> None:
    if args.todo == "TOMORROW":
        return
    if args.all:
        cb = CommandBuilder(sep=";")
        cb.replace(TodoType.LATE, TodoType.TODO, fp=filepath)
        cb.find(TodoType.TODO, fp=filepath)
        cb.append_to(TOMORROW)
        sp.call(str(cb), shell=True)
    else:
        select(args, filepath)
    if args.clear:
        reset_todo(args, TODAY)


def select(args, filepath: str) -> None:
    selection = []
    with tempfile.NamedTemporaryFile(delete=False) as output_file:
        cb = CommandBuilder(sep="|")
        cb.find([TodoType.TODO, TodoType.LATE], fp=filepath)
        cb.strip(TodoType.TODO, prefix=True)
        cb.strip(TodoType.LATE, prefix=True)
        cb.named("sort")
        cb.named(f"fzf > {output_file.name}")
        sp.call(str(cb), shell=True)

        with open(output_file.name, encoding="utf-8") as f:
            for line in f:
                selection.append(line.strip("\n"))
    os.unlink(output_file.name)

    for task in selection:
        task = task.strip()
        cb = CommandBuilder(sep=";")
        if args.func.__name__ == "push":
            cb.find(task, fp=filepath, todo=False)
            cb.append_to(TOMORROW)
            cb.delete(task, filepath, todo=False)
        else:
            cb.replace(
                f"\\[( |>)\\] {task}", f"\\[x\\] {task}", fp=filepath, todo=False
            )
        sp.call(str(cb), shell=True)


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
    cb = CommandBuilder()
    if filetime.date() != today:
        cb.replace(TodoType.TODO, TodoType.LATE, fp=filepath)
        sp.call(str(cb), shell=True)
        clean(args, TODAY)
        cb.find(TodoType.TODO, fp=TOMORROW)
        cb.append_to(TODAY)
        sp.call(str(cb), shell=True)
        reset_todo(args, TOMORROW)
        print("It's a new day  ")

    if args.func:
        args.func(args, filepath)
    else:
        sp.call(["nvim", filepath])
        exit()
