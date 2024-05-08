#!/usr/bin/env python3

import subprocess as sp
import argparse
import os
import datetime as dt


TODAY = "/Users/caseymiller/self/notes/main/tasks/today.md"
TOMORROW = "/Users/caseymiller/self/notes/main/tasks/tomorrow.md"
SELF = "/Users/caseymiller/self/notes/main/tasks/self.md"


def parse_args():
    parser = argparse.ArgumentParser(description="TODO CLI")
    subparsers = parser.add_subparsers(help="commands")
    file = parser.add_mutually_exclusive_group(required=False)
    file.add_argument(
        "-m",
        dest="list",
        action="store_const",
        const="TOMORROW",
        default="TODAY",
        help="use 'tomorrow' tasks file",
    )
    file.add_argument(
        "-s",
        dest="list",
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
    return parser.parse_args()


def ls(args, file):
    try:
        sp.check_output("grep -E '\\[(x| )\\]' {}".format(file), shell=True)
        if args.list == "TODAY":
            print("Here's your tasks for today 󰃶 :")
        else:
            print("Here's your tasks:")
        sp.call(
            "cat {} | grep -E '\\[(x| )\\]' | sed 's/- \\[x\\]//' | sed 's/\\[ \\] //' | sort".format(
                file
            ),
            shell=True,
        )
    except sp.CalledProcessError:
        print("No tasks left to complete!")


def new(args, file):
    tasks = [task for task in input(">>> ").split(", ")]
    with open(file, "a") as f:
        for task in tasks:
            f.write("- [ ] {}\n".format(task))


def clean(args, file):
    sp.call(["sed", "-i", "", "/\\[x\\]/d", file])


def restart(args, file):
    sp.call(["sed", "-i", "", "-E", "/\\[(x| )\\]/d", file])


if __name__ == "__main__":
    args = parse_args()

    match args.list:
        case "TODAY":
            file = TODAY
        case "TOMORROW":
            file = TOMORROW
        case "SELF":
            file = SELF

    today = dt.datetime.now().date()
    filetime = dt.datetime.fromtimestamp(os.path.getmtime(TODAY))
    if filetime.date() != today:
        sp.call(["sed", "-i", "", "-E", "/\\[x\\]/d", TODAY])
        sp.call(["sed", "-i", "", "-E", "/\\[ \\]/\\[>\\]", TODAY])
        sp.call(
            "cat {0} | grep -E '\\[ \\]' >>{1}".format(TOMORROW, TODAY),
            shell=True,
        )
        print("It's a new day  ")

    if args.func is not None:
        args.func(args, file)
    else:
        sp.call(["nvim", file])
        exit()
