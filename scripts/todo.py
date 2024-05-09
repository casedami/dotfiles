#!/usr/bin/env python3

import subprocess as sp
import argparse
import os
import datetime as dt
import tempfile


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
        action="store_false",
        default=True,
        help="push tasks but don't clear",
    )
    command_push.set_defaults(func=push)

    return parser.parse_args()


def ls(args, filepath: str) -> None:
    try:
        sp.check_output("grep -E '\\[(x| |>)\\]' {}".format(filepath), shell=True)
        if args.todo == "TODAY":
            outstr = "Here's your tasks for today:"
        else:
            outstr = "Here's your tasks:"
        print(outstr)
        print("-" * len(outstr))
        commands = [
            f"cat {filepath}",
            "grep -E '\\[(x| |>)\\]'",  # find all tasks in file
            "sed 's/- \\[x\\]/x/'",  # mark completed with 'x'
            "sed 's/- \\[ \\]/-/'",  # mark incompleted with '-'
            "sed 's/- \\[>\\]/>/'",  # mark forwarded with '>'
            "sort",
        ]
        sp.call(" | ".join(commands), shell=True)
    except sp.CalledProcessError:
        print("No tasks left to complete!")


def new(args, filepath: str) -> None:
    try:
        tasks = [task for task in input(">>> ").split(", ")]
        with open(filepath, "a") as f:
            for task in tasks:
                f.write("- [ ] {}\n".format(task))
    except KeyboardInterrupt:
        print()


def clean(args, filepath: str) -> None:
    sp.call(f"sed -i '' -E '/\\[x\\]/d' {filepath}", shell=True)


def restart(args, filepath: str) -> None:
    sp.call(f"sed -i '' -E '/\\[(x| |>)\\]/d' {filepath}", shell=True)


def push(args, filepath: str) -> None:
    if args.todo == "TOMORROW":
        return
    if args.all:
        commands = [
            f"sed -i '' -E 's/\\[>\\]/\\[ \\]/' {filepath}",
            f"grep -E '\\[ \\]' {filepath} >> {TOMORROW}",
        ]
        sp.call(" | ".join(commands), shell=True)
    else:
        select(args, filepath)
    if args.clear:
        restart(args, TODAY)


def select(args, filepath: str) -> None:
    selection = []
    with tempfile.NamedTemporaryFile(delete=False) as output_file:
        commands = [
            f"cat {filepath}",
            "grep -E '\\[( |>)\\]'",  # find incomplete/forwarded tasks
            "sed -E 's/- \\[( |>)\\] //'",  # remove todo prefixes
            f"fzf > {output_file.name}",  # pass to fzf and write selection to temp file
        ]
        sp.call(" | ".join(commands), shell=True)

        with open(output_file.name, encoding="utf-8") as f:
            for line in f:
                selection.append(line.strip("\n"))

    os.unlink(output_file.name)
    for task in selection:
        if args.func:
            commands = [
                f"grep -E '{task}' {filepath} >> {TOMORROW}",  # push selected tasks to tomorrow
                f"sed -i '' '/{task}/d' {filepath}",  # remove selected tasks from file
            ]
            command = " | ".join(commands)
        else:
            command = f"sed -i '' -E 's/\\[( |>)\\] {task}/\\[x\\] {task}/' {filepath}"
        sp.call(command, shell=True)


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
    if filetime.date() != today:
        sp.call(f"sed -i '' -E 's/\\[ \\]/\\[>\\]/' {TODAY}", shell=True)
        clean(args, TODAY)
        sp.call(f"cat {TOMORROW} | grep -E '\\[ \\]' >>{TODAY}", shell=True)
        restart(args, TOMORROW)
        print("It's a new day  ")

    if args.func:
        args.func(args, filepath)
    else:
        sp.call(["nvim", filepath])
        exit()
