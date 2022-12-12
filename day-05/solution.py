#!/usr/bin/env python3

State = dict[int, list[str]]


def parse_setup(input: list[str]) -> State:
    r = {}

    for line in input:
        for i in range(1, len(line), 4):
            if line[i] == " ":
                continue
            containers = r.get(1 + i // 4, [])
            containers.append(line[i])
            r[1 + i // 4] = containers

    for list in r.values():
        list.reverse()

    return r


def execute(s: State, program: list[str], crane):
    for command in program:
        if not command:
            continue
        how_many, src, dst = [
            int(field)
            for field in command.split()
            if all(c in "0123456789" for c in field)
        ]
        s[dst] += crane(s[src][-how_many:])
        s[src] = s[src][:-how_many]


def solution(crane):
    state = parse_setup(setup)
    execute(state, program, crane)
    message = "".join(state[i][-1] for i in range(1, len(state) + 1) if state[i])
    print(message)


with open("./input.txt") as f:
    input = [line.rstrip() for line in f.readlines()]
    split = input.index("")
    setup, program = input[: split - 1], input[split:]
    solution(reversed)
    solution(lambda x: x)
