import datetime as dt
from enum import StrEnum


class TodoType(StrEnum):
    TODO = " "
    DONE = "x"
    LATE = ">"


class Priority:
    """
    Represents the priority of a task. The priority level and date are used
    for ordering.

    Priority is ordered as follows:
        - higher priority level and dated sooner
        - higher priority level
        - dated
    """

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
        if other is None or other.level is None:
            return True
        if self.level is None:
            return False
        if self.date is None or other.date is None:
            return self.level[-1] < other.level[-1]
        if self.date == other.date:
            return self.level[-1] < other.level[-1]
        if self.date < other.date:
            return True
        if self.date > other.date:
            return False


class CommandBuilder:
    """
    Builder utility class for terminal commands, especially for managing TODO CLI.
    """

    def __init__(self, sep: str | None = None) -> None:
        if sep not in ("|", ";", None):
            raise ValueError("Invalid command separator. Use '|' or ';'")
        self.command = ""
        self.sep = sep

    def __str__(self):
        return self.command

    def build(self):
        return self.command

    def named(self, cmd: str):
        self.command = f" {self.sep} ".join(filter(None, [self.command, cmd]))
        return self

    def find(self, p: str | list[str], fp: str | None = None, todo: bool = True):
        if isinstance(p, list):
            pattern = f"({'|'.join(p)})"
        else:
            pattern = p

        if todo:
            pattern = f"\\[{pattern}\\]"

        if fp:
            cmd = f"grep -E '{pattern}' {fp}"
        else:
            cmd = f"grep -E '{pattern}'"

        self.command = f" {self.sep} ".join(filter(None, [self.command, cmd]))
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
            cmd = f"sed -i '' -E 's/{orig}/{new}/' {fp}"
        else:
            cmd = f"sed -E 's/{orig}/{new}/'"

        self.command = f" {self.sep} ".join(filter(None, [self.command, cmd]))
        return self

    def delete(self, p: str | list[str], fp: str, todo: bool = True):
        if isinstance(p, list):
            pattern = "|".join(p)
        else:
            pattern = p
        if todo:
            pattern = f"\\[({pattern})\\]"

        cmd = f"sed -i '' -E '/({pattern})/d' {fp}"
        self.command = f" {self.sep} ".join(filter(None, [self.command, cmd]))
        return self

    def strip(self, p: str, prefix: bool = False, priority: bool = False):
        if priority:
            cmd_pr = f"sed -E 's/(- \\[{p}\\] .+)#(high|medium|low)((.+)?)/\\1/'"
        else:
            cmd_pr = None
        if prefix:
            cmd = f"sed -E 's/- \\[{p}\\]//'"
        else:
            match p:
                case TodoType.TODO:
                    cmd = f"sed -E 's/- \\[{p}\\]/-/'"
                case TodoType.DONE:
                    cmd = f"sed -E 's/- \\[{p}\\]/󰅖/'"
                case TodoType.LATE:
                    cmd = f"sed -E 's/- \\[{p}\\]/>/'"

        self.command = f" {self.sep} ".join(filter(None, [self.command, cmd_pr, cmd]))
        return self
