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
    parser_ls = subparsers.add_parser("ls", help="list tasks")
    parser_ls.set_defaults(func=ls)
    parser_new = subparsers.add_parser("new", help="create new task")
    parser_new.set_defaults(func=new)
    parser_clean = subparsers.add_parser("clean", help="remove finished tasks")
    parser_clean.set_defaults(func=clean)
    parser_restart = subparsers.add_parser("restart", help="remove all tasks")
    parser_restart.set_defaults(func=restart)
    parser_select = subparsers.add_parser("mk", help="select tasks to mark complete")
    parser_select.set_defaults(func=select)
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
            "sed 's/- \\[x\\]/ x/'",  # mark completed with 'x'
            "sed 's/- \\[ \\]/ -/'",  # mark incompleted with '-'
            "sed 's/- \\[>\\]/ >/'",  # mark forwarded with '>'
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
    sp.call(f"sed -i '' '/\\[x\\]/d' {filepath}")


def restart(args, filepath: str) -> None:
    sp.call(f"sed -i '' -E '/\\[(x| )\\]/d' {filepath}")


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
        sp.call(
            f"sed -i '' -E 's/\\[( |>)\\] {task}/\\[x\\] {task}/' {filepath}",
            shell=True,
        )
        print(f"Marked as complete: '{task}'")


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
        sp.call(f"sed -i '' -E 's/\\[ \\]/\\[>\\]/' {TODAY}")
        clean(args, TODAY)
        sp.call(f"cat {TOMORROW} | grep -E '\\[ \\]' >>{TODAY}", shell=True)
        restart(args, TOMORROW)
        print("It's a new day  ")

    if args.func is not None:
        args.func(args, filepath)
    else:
        sp.call(["nvim", filepath])
        exit()
