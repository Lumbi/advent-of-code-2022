use std::fs;
use std::io;
use std::io::BufRead;

struct Memory {
    register_x: i32,
    cycle: i32,
    signal_strength: i32,
    crt: i32,
}

fn main() {
    let input_file = fs::File::open("input.txt");
    if let Ok(input_file) = input_file {
        let lines = io::BufReader::new(input_file).lines();

        println!("star2:");

        let mut memory = Memory {
            register_x: 1,
            cycle: 0,
            signal_strength: 0,
            crt: 0,
        };

        for line in lines {
            if let Ok(instruction) = line {
                execute(&instruction, &mut memory);
            }
        }

        println!("star1: {}", memory.signal_strength);
    }
}

fn execute(instruction: &str, memory: &mut Memory) {
    let mut parts = instruction.split(" ");
    let operation = parts.next();
    if operation == Some("addx") {
        let arg = parts.next().expect("addx arg").to_string().parse::<i32>().unwrap();
        run_cycle(memory);
        run_cycle(memory);
        memory.register_x += arg;
    } else if operation == Some("noop") {
        run_cycle(memory);
    }
}

fn run_cycle(memory: &mut Memory) {
    crt_trace(memory);

    memory.cycle += 1;
    if ((memory.cycle - 20) % 40) == 0 {
        memory.signal_strength += (memory.register_x) * (memory.cycle);
    }
}

fn crt_trace(memory: &mut Memory) {
    memory.crt = memory.crt % 40;
    if memory.crt >= (memory.register_x - 1) && memory.crt <= (memory.register_x + 1) {
        print!("#");
    } else {
        print!(".");
    }

    memory.crt += 1;

    if memory.crt == 40 {
        println!();
    }
}
