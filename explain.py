#!/usr/bin/env python3
import json
import re
import shlex
import subprocess
import sys
import textwrap
from typing import Dict, List, Optional, Tuple

try:
    import yaml  # type: ignore
except Exception:  # pragma: no cover - optional dependency
    yaml = None  # type: ignore

COLOR_RESET = "\033[0m"
COLOR_PROMPT = "\033[38;5;39m"
COLOR_TITLE = "\033[1;38;5;220m"
COLOR_NAME = "\033[1;38;5;70m"
COLOR_DESC = "\033[38;5;244m"
COLOR_ERROR = "\033[1;31m"

CONTROL_TASK_KEYS = {
    "name",
    "vars",
    "register",
    "when",
    "become",
    "delegate_to",
    "with_items",
    "loop",
    "loop_control",
    "environment",
    "tags",
    "notify",
    "ignore_errors",
    "args",
}


def color(text: str, code: str) -> str:
    return f"{code}{text}{COLOR_RESET}"


def run_subprocess(command: List[str]) -> Tuple[int, str, str]:
    try:
        completed = subprocess.run(
            command,
            check=False,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
        )
    except FileNotFoundError:
        return 127, "", f"Command not found: {' '.join(command)}"
    return completed.returncode, completed.stdout, completed.stderr


def detect_input_type(text: str) -> str:
    stripped = text.strip()
    if not stripped:
        return "unknown"

    if looks_like_yaml(stripped):
        return "ansible"
    return "shell"


def looks_like_yaml(text: str) -> bool:
    if yaml is None:
        # Heuristic fallback: look for colon-separated key/value pairs and indentation
        colon_lines = sum(1 for line in text.splitlines() if ":" in line)
        dash_lines = sum(1 for line in text.splitlines() if line.lstrip().startswith("-"))
        return colon_lines > 1 or dash_lines > 1
    try:
        data = yaml.safe_load(text)
    except Exception:
        return False
    return isinstance(data, (dict, list))


def get_man_page(command: str) -> Optional[str]:
    ret, out, err = run_subprocess(["man", "-P", "cat", command])
    if ret == 0 and out.strip():
        return out
    return None


def get_command_help(command: str) -> Optional[str]:
    ret, out, err = run_subprocess([command, "--help"])
    if ret == 0 or out:
        return out
    return None


def extract_name_section(man_text: str) -> Optional[str]:
    if not man_text:
        return None
    pattern = re.compile(r"^NAME\n(.+?)(?:\n\n|$)", re.DOTALL)
    match = pattern.search(man_text)
    if match:
        return match.group(1).strip()
    return None


def parse_help_options(help_text: str) -> Dict[str, str]:
    options: Dict[str, str] = {}
    if not help_text:
        return options
    lines = help_text.splitlines()
    i = 0
    while i < len(lines):
        line = lines[i]
        option_match = re.match(r"\s{0,6}(-{1,2}[\w\-?]+(?:,\s*-{1,2}[\w\-?]+)*)\s+(.*)", line)
        if option_match:
            names = option_match.group(1)
            desc = option_match.group(2).strip()
            i += 1
            while i < len(lines) and lines[i].startswith(" " * 8):
                desc += " " + lines[i].strip()
                i += 1
            for name in re.split(r",\s*", names):
                normalized = name.strip()
                if normalized:
                    options[normalized] = desc
            continue
        i += 1
    return options


def describe_command(command_line: str) -> None:
    try:
        parts = shlex.split(command_line)
    except ValueError as exc:
        print(color(f"Could not parse command: {exc}", COLOR_ERROR))
        return

    if not parts:
        print(color("No command to explain.", COLOR_ERROR))
        return

    command = parts[0]
    man_text = get_man_page(command)
    help_text = get_command_help(command)
    option_help = parse_help_options(help_text or man_text or "")

    print(color("Command", COLOR_TITLE))
    print(f"  {color(command, COLOR_NAME)}")

    if man_text:
        name_section = extract_name_section(man_text)
        if name_section:
            print(color("Summary", COLOR_TITLE))
            for line in textwrap.wrap(name_section, width=80):
                print(f"  {line}")
    elif help_text:
        first_line = help_text.strip().splitlines()[0]
        print(color("Summary", COLOR_TITLE))
        for line in textwrap.wrap(first_line, width=80):
            print(f"  {line}")

    if len(parts) > 1:
        print(color("Arguments", COLOR_TITLE))
        for arg in parts[1:]:
            name = arg
            desc = ""
            lookup_key = arg
            if "=" in lookup_key:
                lookup_key = lookup_key.split("=", 1)[0]
            if lookup_key.startswith("--") and lookup_key not in option_help:
                # try to match prefix (e.g., --option=value)
                for opt_name in option_help:
                    if opt_name.startswith(lookup_key):
                        desc = option_help[opt_name]
                        break
            if not desc:
                desc = option_help.get(lookup_key) or option_help.get(arg[:2]) or ""
            if not desc and arg.startswith("-") and len(arg) > 2 and not arg.startswith("--"):
                # short options squashed together
                letters = arg[1:]
                combined_desc = []
                for letter in letters:
                    opt = f"-{letter}"
                    if opt in option_help:
                        combined_desc.append(f"{opt}: {option_help[opt]}")
                if combined_desc:
                    desc = "; ".join(combined_desc)
            if desc:
                for line in textwrap.wrap(desc, width=74):
                    print(f"  {color(name, COLOR_NAME)}  {line}")
            else:
                print(f"  {color(name, COLOR_NAME)}  (no description found)")

    overall = build_command_summary(command, parts[1:], man_text, help_text)
    if overall:
        print(color("Overall", COLOR_TITLE))
        for line in textwrap.wrap(overall, width=80):
            print(f"  {line}")


def build_command_summary(command: str, args: List[str], man_text: Optional[str], help_text: Optional[str]) -> Optional[str]:
    if man_text:
        name_section = extract_name_section(man_text)
        if name_section:
            parts = name_section.split(" - ", 1)
            if len(parts) == 2:
                return f"Runs `{command}` to {parts[1].strip()} with arguments: {' '.join(args)}".strip()
    if help_text:
        first_line = help_text.strip().splitlines()[0]
        return f"Runs `{command}`. {first_line}"
    if args:
        return f"Runs `{command}` with arguments: {' '.join(args)}"
    return f"Runs `{command}`"


def describe_ansible_task(text: str) -> None:
    if yaml is None:
        print(color("YAML support is not available (PyYAML is missing).", COLOR_ERROR))
        return
    try:
        data = yaml.safe_load(text)
    except Exception as exc:
        print(color(f"Unable to parse YAML: {exc}", COLOR_ERROR))
        return

    tasks: List[dict]
    if isinstance(data, list):
        tasks = [task for task in data if isinstance(task, dict)]
    elif isinstance(data, dict):
        if "tasks" in data and isinstance(data["tasks"], list):
            tasks = [task for task in data["tasks"] if isinstance(task, dict)]
        else:
            tasks = [data]
    else:
        print(color("No Ansible tasks found in the provided YAML.", COLOR_ERROR))
        return

    if not tasks:
        print(color("No Ansible tasks found in the provided YAML.", COLOR_ERROR))
        return

    for index, task in enumerate(tasks, start=1):
        print(color(f"Task {index}", COLOR_TITLE))
        task_name = task.get("name")
        if task_name:
            print(f"  {color(task_name, COLOR_NAME)}")

        module_name, module_args = determine_module(task)
        if not module_name:
            print("  Could not determine module for this task.")
            continue

        print(color("  Module", COLOR_DESC))
        print(f"    {color(module_name, COLOR_NAME)}")

        doc_info = fetch_ansible_doc(module_name)
        if doc_info:
            short_desc = doc_info.get("short_description")
            if short_desc:
                print(color("  Summary", COLOR_DESC))
                for line in textwrap.wrap(short_desc, width=76):
                    print(f"    {line}")

        if module_args:
            print(color("  Arguments", COLOR_DESC))
            options_doc = (doc_info or {}).get("options", {}) if doc_info else {}
            for key, value in module_args.items():
                desc = ""
                if isinstance(value, (dict, list)):
                    value_repr = json.dumps(value, indent=2)
                else:
                    value_repr = str(value)
                if isinstance(options_doc, dict) and key in options_doc:
                    option_entry = options_doc[key]
                    desc = option_entry.get("description")
                    if isinstance(desc, list):
                        desc = " ".join(d.strip() for d in desc)
                if desc:
                    wrapped_desc = textwrap.wrap(desc, width=70)
                    if wrapped_desc:
                        print(f"    {color(key, COLOR_NAME)} = {value_repr}")
                        for line in wrapped_desc:
                            print(f"      {line}")
                        continue
                print(f"    {color(key, COLOR_NAME)} = {value_repr}")

        if doc_info:
            long_desc = doc_info.get("description")
            if isinstance(long_desc, list) and long_desc:
                print(color("  Overall", COLOR_DESC))
                for line in textwrap.wrap(" ".join(long_desc), width=76):
                    print(f"    {line}")
        print()


def determine_module(task: dict) -> Tuple[Optional[str], Dict[str, object]]:
    for key, value in task.items():
        if key in CONTROL_TASK_KEYS:
            continue
        if isinstance(value, dict):
            return key, value
        if isinstance(value, list):
            return key, {"items": value}
        return key, {"value": value}
    return None, {}


def fetch_ansible_doc(module: str) -> Optional[dict]:
    ret, out, err = run_subprocess(["ansible-doc", "-j", module])
    if ret != 0 or not out.strip():
        if err.strip():
            print(color(err.strip(), COLOR_ERROR))
        return None
    try:
        doc = json.loads(out)
    except json.JSONDecodeError as exc:
        print(color(f"Failed to parse ansible-doc output: {exc}", COLOR_ERROR))
        return None
    return doc.get(module)


def main() -> None:
    print(color("Explain - Offline command and Ansible task explainer", COLOR_TITLE))
    print("Paste commands or YAML. Submit with an empty line. Type 'exit' or 'quit' to leave.")

    buffer: List[str] = []
    while True:
        prompt = color("explain> ", COLOR_PROMPT) if not buffer else color("... ", COLOR_PROMPT)
        try:
            line = input(prompt)
        except EOFError:
            print()
            break
        except KeyboardInterrupt:
            print()
            break

        if not buffer and line.strip().lower() in {"exit", "quit"}:
            break

        if not line.strip() and buffer:
            text = "\n".join(buffer).strip()
            buffer = []
            if not text:
                continue
            input_type = detect_input_type(text)
            if input_type == "shell":
                describe_command(text)
            elif input_type == "ansible":
                describe_ansible_task(text)
            else:
                print(color("Could not determine input type.", COLOR_ERROR))
            continue

        if not line.strip():
            continue

        buffer.append(line)

    print(color("Goodbye!", COLOR_TITLE))


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print()
        print(color("Goodbye!", COLOR_TITLE))
        sys.exit(0)
